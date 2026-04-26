# Tests a database contract fulfilled across two modular services.
#
# - `webapp`  (consumer): requests a database via the `database` contract,
#                         using `contracts.database.want` and reading results
#                         from `config.contracts.database.results` directly.
# - `fakedb`  (provider): fulfils database requests by assigning socket paths
#                         and creating the directories at runtime with a oneshot
#                         systemd unit, so the consumer can verify them.
#
# The test checks both the eval-time contract plumbing (assertions) and the
# runtime result (the consumer writes its socket path to a file that the test
# script reads back).
{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;

  # Database contract definition, inline (not a lib-level contract).
  dbContractDef = {
    meta = {
      description = ''
        Contract for database provisioning where a consumer requests a named
        database and a provider sets it up and returns a connection socket path.
      '';
      maintainers = with lib.maintainers; [ kiara ];
    };
    interface = {
      request.name = mkOption {
        description = "Name for the database to provision.";
        type = types.str;
      };
      result.socketPath = mkOption {
        description = "Path to the UNIX socket file for connecting to the database.";
        type = types.str;
      };
    };
  };

  dbContract = lib.evalOption (mkOption { type = lib.contract.templateType; }) dbContractDef;
  inherit (dbContract) mkContract mkProviderType;
in
{
  name = "contracts-database-modular-services";

  containers.machine =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      # Consumer: a webapp that needs one database.
      # Uses `contracts.database.want` and reads results from `config.contracts.database.results`.
      webappModule =
        {
          lib,
          config,
          name,
          ...
        }:
        {
          _class = "service";

          options.webapp.db = mkOption {
            type = mkContract {
              request.name.default = "webapp_${name}";
            };
          };

          config = {
            contracts.database.want = {
              inherit (config.webapp) db;
            };

            webapp.db.result = config.contracts.database.results.db;

            # Write the received socket path to a file so the test script can
            # verify it without needing to know the path at test-script write time.
            process.argv = [
              "${pkgs.bash}/bin/sh"
              "-c"
              "echo ${lib.escapeShellArg config.webapp.db.result.socketPath} > /tmp/webapp-socket-path"
            ];

            systemd.service = {
              wantedBy = [ "multi-user.target" ];
              after = [ "fakedb.service" ];
              requires = [ "fakedb.service" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              serviceConfig.Restart = lib.mkForce "no";
            };
          };
        };

      # Provider: a fake database that assigns a UNIX socket path to every
      # requested database and creates the directory at activation time.
      fakedbModule =
        {
          lib,
          config,
          options,
          ...
        }:
        {
          _class = "service";

          options.fakedb = mkOption {
            description = "Database contract instances fulfilled by this fake-db provider.";
            default = config.contracts.database.requests;
            type = mkProviderType {
              # Derive the socket path from the requested database name.
              fulfill =
                { name }:
                {
                  socketPath = "/run/fakedb/${name}";
                };
            };
          };

          config = {
            contracts.database.providers.fakedb.module = options.fakedb;

            # Create the socket directories for every provisioned database.
            process.argv = [
              "${pkgs.bash}/bin/sh"
              "-c"
              (lib.concatStringsSep "\n" (
                lib.flatten (
                  lib.mapAttrsToList (
                    _instance: lib.mapAttrsToList (_db: v: "mkdir -p ${lib.escapeShellArg v.result.socketPath}")
                  ) config.fakedb
                )
              ))
            ];

            systemd.service = {
              wantedBy = [ "multi-user.target" ];
              serviceConfig.Type = "oneshot";
              serviceConfig.RemainAfterExit = true;
              serviceConfig.Restart = lib.mkForce "no";
            };
          };
        };
    in
    {
      contractTypes.database = dbContractDef;

      system.services.instance = {
        imports = [ webappModule ];
      };

      system.services.fakedb = {
        imports = [ fakedbModule ];
      };

      contracts.database.defaultProviderName = "fakedb";

      # Eval-time check: the contract plumbing resolves the correct socket path.
      assertions = [
        {
          assertion =
            config.contracts.database.results.instance.db.socketPath == "/run/fakedb/webapp_instance";
          message = ''
            \n            database contract: consumer should receive socketPath
                        '/run/fakedb/webapp_instance' from the fakedb provider
          '';
        }
      ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # Runtime check: the consumer wrote the socket path it received to a file.
    socket_path = machine.succeed("cat /tmp/webapp-socket-path").strip()
    assert socket_path == "/run/fakedb/webapp_instance", \
        f"Expected '/run/fakedb/webapp_instance', got '{socket_path}'"

    # The provider created the directory.
    machine.succeed("test -d /run/fakedb/webapp_instance")
  '';

  meta.maintainers = with lib.maintainers; [ kiara ];
}
