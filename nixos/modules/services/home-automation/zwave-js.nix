{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.zwave-js;
  mergedConfigFile = "/run/zwave-js/config.json";
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.zwave-js = {
    enable = lib.mkEnableOption "the zwave-js server on boot";

    package = lib.mkPackageOption pkgs "zwave-js-server" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = ''
        Port for the server to listen on.
      '';
    };

    serialPort = lib.mkOption {
      type = lib.types.path;
      description = ''
        Serial port device path for Z-Wave controller.
      '';
      example = "/dev/ttyUSB0";
    };

    secretsConfigFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        JSON file containing secret keys. A dummy example:

        ```
        {
          "securityKeys": {
            "S0_Legacy": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
            "S2_Unauthenticated": "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
            "S2_Authenticated": "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC",
            "S2_AccessControl": "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD"
          }
        }
        ```

        See
        <https://zwave-js.github.io/node-zwave-js/#/getting-started/security-s2>
        for details. This file will be merged with the module-generated config
        file (taking precedence).

        Z-Wave keys can be generated with:

          {command}`< /dev/urandom tr -dc A-F0-9 | head -c32 ;echo`


        ::: {.warning}
        A file in the nix store should not be used since it will be readable to
        all users.
        :::
      '';
      example = "/secrets/zwave-js-keys.json";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          storage = {
            cacheDir = lib.mkOption {
              type = lib.types.path;
              default = "/var/cache/zwave-js";
              readOnly = true;
              description = "Cache directory";
            };
          };
        };
      };
      default = { };
      description = ''
        Configuration settings for the generated config file.

        This config is combined with the contents of `secretsConfigFile` and
        passed to zwave-js-server via `--config`. The project's README [1]
        states that the config must follow the Z-Wave JS config format [2].

        [1]: https://github.com/zwave-js/zwave-js-server/tree/master
        [2]: https://zwave-js.github.io/node-zwave-js/#/api/driver?id=zwaveoptions

        ::: {.warning}
        Secrets should go in `secretsConfigFile`. The contents of `settings` is
        written to the nix store, which is world-readable.
        :::
      '';
    };

    extraFlags = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [ "--mock-driver" ];
      description = ''
        Extra flags to pass to command
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.zwave-js =
      let
        configFile = settingsFormat.generate "zwave-js-config.json" cfg.settings;
      in
      {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "Z-Wave JS Server";
        serviceConfig = {
          ExecStartPre = ''
            /bin/sh -c "${pkgs.jq}/bin/jq -s '.[0] * .[1]' ${configFile} %d/secrets.json > ${mergedConfigFile}"
          '';
          LoadCredential = "secrets.json:${cfg.secretsConfigFile}";
          ExecStart = lib.concatStringsSep " " [
            "${cfg.package}/bin/zwave-server"
            "--config ${mergedConfigFile}"
            "--port ${toString cfg.port}"
            cfg.serialPort
            (lib.escapeShellArgs cfg.extraFlags)
          ];
          Restart = "on-failure";
          User = "zwave-js";
          SupplementaryGroups = [ "dialout" ];
          CacheDirectory = "zwave-js";
          RuntimeDirectory = "zwave-js";

          # Hardening
          CapabilityBoundingSet = "";
          DeviceAllow = [ cfg.serialPort ];
          DevicePolicy = "closed";
          DynamicUser = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = false;
          NoNewPrivileges = true;
          PrivateUsers = true;
          PrivateTmp = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          RemoveIPC = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service @pkey"
            "~@privileged @resources"
          ];
          UMask = "0077";
        };
      };
  };

  meta.maintainers = with lib.maintainers; [ graham33 ];
}
