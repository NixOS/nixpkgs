{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.matrix-conduit;

  format = pkgs.formats.toml {};
  configFile = format.generate "conduit.toml" cfg.settings;
in
  {
    meta.maintainers = with maintainers; [ pstn piegames ];
    options.services.matrix-conduit = {
      enable = mkEnableOption "matrix-conduit";

      extraEnvironment = mkOption {
        type = types.attrsOf types.str;
        description = "Extra Environment variables to pass to the conduit server.";
        default = {};
        example = { RUST_BACKTRACE="yes"; };
      };

      package = mkOption {
        type = types.package;
        default = pkgs.matrix-conduit;
        defaultText = "pkgs.matrix-conduit";
        example = "pkgs.matrix-conduit";
        description = ''
          Package of the conduit matrix server to use.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;
          options = {
            global.server_name = mkOption {
              type = types.str;
              example = "example.com";
              description = "The server_name is the name of this server. It is used as a suffix for user # and room ids.";
            };
            global.port = mkOption {
              type = types.port;
              default = 6167;
              description = "The port Conduit will be running on. You need to set up a reverse proxy in your web server (e.g. apache or nginx), so all requests to /_matrix on port 443 and 8448 will be forwarded to the Conduit instance running on this port";
            };
            global.max_request_size = mkOption {
              type = types.ints.positive;
              default = 20000000;
              description = "Max request size in bytes. Don't forget to also change it in the proxy.";
            };
            global.allow_registration = mkOption {
              type = types.bool;
              default = false;
              description = "Whether new users can register on this server.";
            };
            global.allow_encryption = mkOption {
              type = types.bool;
              default = true;
              description = "Whether new encrypted rooms can be created. Note: existing rooms will continue to work.";
            };
            global.allow_federation = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether this server federates with other servers.
              '';
            };
            global.trusted_servers = mkOption {
              type = types.listOf types.str;
              default = [ "matrix.org" ];
              description = "Servers trusted with signing server keys.";
            };
            global.address = mkOption {
              type = types.str;
              default = "::1";
              description = "Address to listen on for connections by the reverse proxy/tls terminator.";
            };
            global.database_path = mkOption {
              type = types.str;
              default = "/var/lib/matrix-conduit/";
              readOnly = true;
              description = ''
                Path to the conduit database, the directory where conduit will save its data.
                Note that due to using the DynamicUser feature of systemd, this value should not be changed
                and is set to be read only.
              '';
            };
            global.database_backend = mkOption {
              type = types.enum [ "sqlite" "rocksdb" ];
              default = "sqlite";
              example = "rocksdb";
              description = ''
                The database backend for the service. Switching it on an existing
                instance will require manual migration of data.
              '';
            };
          };
        };
        default = {};
        description = ''
            Generates the conduit.toml configuration file. Refer to
            <link xlink:href="https://gitlab.com/famedly/conduit/-/blob/master/conduit-example.toml"/>
            for details on supported values.
            Note that database_path can not be edited because the service's reliance on systemd StateDir.
        '';
      };
    };

    config = mkIf cfg.enable {
      systemd.services.conduit = {
        description = "Conduit Matrix Server";
        documentation = [ "https://gitlab.com/famedly/conduit/" ];
        wantedBy = [ "multi-user.target" ];
        environment = lib.mkMerge ([
          { CONDUIT_CONFIG = configFile; }
          cfg.extraEnvironment
        ]);
        serviceConfig = {
          DynamicUser = true;
          User = "conduit";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateUsers = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          StateDirectory = "matrix-conduit";
          ExecStart = "${cfg.package}/bin/conduit";
          Restart = "on-failure";
          RestartSec = 10;
          StartLimitBurst = 5;
        };
      };
    };
  }
