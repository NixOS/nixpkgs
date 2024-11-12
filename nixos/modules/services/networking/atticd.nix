{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) types;

  cfg = config.services.atticd;

  format = pkgs.formats.toml { };

  checkedConfigFile =
    pkgs.runCommand "checked-attic-server.toml"
      {
        configFile = format.generate "server.toml" cfg.settings;
      }
      ''
        export ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64="$(${lib.getExe pkgs.openssl} genrsa -traditional 4096 | ${pkgs.coreutils}/bin/base64 -w0)"
        export ATTIC_SERVER_DATABASE_URL="sqlite://:memory:"
        ${lib.getExe cfg.package} --mode check-config -f $configFile
        cat <$configFile >$out
      '';

  atticadmShim = pkgs.writeShellScript "atticadm" ''
    if [ -n "$ATTICADM_PWD" ]; then
      cd "$ATTICADM_PWD"
      if [ "$?" != "0" ]; then
        >&2 echo "Warning: Failed to change directory to $ATTICADM_PWD"
      fi
    fi

    exec ${cfg.package}/bin/atticadm -f ${checkedConfigFile} "$@"
  '';

  atticadmWrapper = pkgs.writeShellScriptBin "atticd-atticadm" ''
    exec systemd-run \
      --quiet \
      --pipe \
      --pty \
      --same-dir \
      --wait \
      --collect \
      --service-type=exec \
      --property=EnvironmentFile=${cfg.environmentFile} \
      --property=DynamicUser=yes \
      --property=User=${cfg.user} \
      --property=Environment=ATTICADM_PWD=$(pwd) \
      --working-directory / \
      -- \
      ${atticadmShim} "$@"
  '';

  hasLocalPostgresDB =
    let
      url = cfg.settings.database.url or "";
      localStrings = [
        "localhost"
        "127.0.0.1"
        "/run/postgresql"
      ];
      hasLocalStrings = lib.any (lib.flip lib.hasInfix url) localStrings;
    in
    config.services.postgresql.enable && lib.hasPrefix "postgresql://" url && hasLocalStrings;
in
{
  options = {
    services.atticd = {
      enable = lib.mkEnableOption "the atticd, the Nix Binary Cache server";

      package = lib.mkPackageOption pkgs "attic-server" { };

      environmentFile = lib.mkOption {
        description = ''
          Path to an EnvironmentFile containing required environment
          variables:

          - ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64: The base64-encoded RSA PEM PKCS1 of the
            RS256 JWT secret. Generate it with `openssl genrsa -traditional 4096 | base64 -w0`.
        '';
        type = types.nullOr types.path;
        default = null;
      };

      user = lib.mkOption {
        description = ''
          The group under which attic runs.
        '';
        type = types.str;
        default = "atticd";
      };

      group = lib.mkOption {
        description = ''
          The user under which attic runs.
        '';
        type = types.str;
        default = "atticd";
      };

      settings = lib.mkOption {
        description = ''
          Structured configurations of atticd.
          See https://github.com/zhaofengli/attic/blob/main/server/src/config-template.toml
        '';
        type = format.type;
        default = { };
      };

      mode = lib.mkOption {
        description = ''
          Mode in which to run the server.

          'monolithic' runs all components, and is suitable for single-node deployments.

          'api-server' runs only the API server, and is suitable for clustering.

          'garbage-collector' only runs the garbage collector periodically.

          A simple NixOS-based Attic deployment will typically have one 'monolithic' and any number of 'api-server' nodes.

          There are several other supported modes that perform one-off operations, but these are the only ones that make sense to run via the NixOS module.
        '';
        type = lib.types.enum [
          "monolithic"
          "api-server"
          "garbage-collector"
        ];
        default = "monolithic";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.environmentFile != null;
        message = ''
          <option>services.atticd.environmentFile</option> is not set.

          Run `openssl genrsa -traditional 4096 | base64 -w0` and create a file with the following contents:

          ATTIC_SERVER_TOKEN_RS256_SECRET="output from command"

          Then, set `services.atticd.environmentFile` to the quoted absolute path of the file.
        '';
      }
    ];

    services.atticd.settings = {
      chunking = lib.mkDefault {
        nar-size-threshold = 65536;
        min-size = 16384; # 16 KiB
        avg-size = 65536; # 64 KiB
        max-size = 262144; # 256 KiB
      };

      database.url = lib.mkDefault "sqlite:///var/lib/atticd/server.db?mode=rwc";

      # "storage" is internally tagged
      # if the user sets something the whole thing must be replaced
      storage = lib.mkDefault {
        type = "local";
        path = "/var/lib/atticd/storage";
      };
    };

    systemd.services.atticd = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ] ++ lib.optionals hasLocalPostgresDB [ "postgresql.service" ];
      requires = lib.optionals hasLocalPostgresDB [ "postgresql.service" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -f ${checkedConfigFile} --mode ${cfg.mode}";
        EnvironmentFile = cfg.environmentFile;
        StateDirectory = "atticd"; # for usage with local storage and sqlite
        DynamicUser = true;
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = 10;

        CapabilityBoundingSet = [ "" ];
        DeviceAllow = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths =
          let
            path = cfg.settings.storage.path;
            isDefaultStateDirectory = path == "/var/lib/atticd" || lib.hasPrefix "/var/lib/atticd/" path;
          in
          lib.optionals (cfg.settings.storage.type or "" == "local" && !isDefaultStateDirectory) [ path ];
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };

    environment.systemPackages = [
      atticadmWrapper
    ];
  };
}
