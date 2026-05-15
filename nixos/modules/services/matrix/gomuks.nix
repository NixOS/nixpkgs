{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;

  settingsFormat = pkgs.formats.yaml { };

in
{

  options.services.gomuks = lib.mkOption {
    description = "Configuration for gomuks instances.";
    default = { };
    type = types.attrsOf (
      types.submodule {
        options = {
          enable = (lib.mkEnableOption "gomuks, a Matrix client written in Go.") // {
            default = true;
          };

          package = lib.mkPackageOption pkgs "gomuks" { };

          settings = lib.mkOption {
            default = { };
            description = ''
              Contents of the gomuks YAML config.
            '';
            type = types.submodule {
              freeformType = settingsFormat.type;
              options = {
                web = {
                  listen_address = lib.mkOption {
                    type = types.str;
                    default = "localhost:29325";
                    description = ''
                      The address and port that gomuks will listen on.
                    '';
                  };

                  username = lib.mkOption {
                    type = types.str;
                    description = ''
                      Username for basic http authentication.
                    '';
                  };

                  password_hash = lib.mkOption {
                    type = types.str;
                    description = ''
                      `bcrypt`ed password for basic http authentication.
                    '';
                  };

                  DisableAuthBecauseIWantMyAccountToBeHacked = lib.mkOption {
                    type = with types; nullOr bool;
                    visible = false;
                    default = null;
                  };
                };

                logging.writers = lib.mkOption {
                  type = with types; listOf attrs;
                  visible = false;
                  default = [
                    {
                      type = "stdout";
                      format = "pretty-colored";
                    }
                  ];
                };
              };
            };
          };
        };
      }
    );
  };

  config = {
    assertions = lib.flatten (
      lib.flip lib.mapAttrsToList config.services.gomuks (
        name: cfg: [
          {
            assertion = (
              (cfg.settings.web.DisableAuthBecauseIWantMyAccountToBeHacked != true)
              && ((cfg.settings.web ? username) || (cfg.settings.web ? password_hash))
            );
            message = ''
              You need to set at least `services.gomuks.${name}.settings.web.username` and
              `services.gomuks.${name}.settings.web.password_hash` in the settings.
            '';
          }
        ]
      )
    );

    systemd.services = lib.flip lib.mapAttrs' config.services.gomuks (
      name: cfg:
      (lib.nameValuePair "gomuks-${name}" (
        let
          settingsFile = settingsFormat.generate "gomuks-${name}.yaml" (
            lib.filterAttrsRecursive (name: value: value != null) cfg.settings
          );

        in
        {
          enable = cfg.enable;
          description = "A Matrix client written in Go";

          restartTriggers = [ settingsFile ];

          wantedBy = [ "multi-user.target" ];

          environment = {
            HOME = lib.mkDefault "%S/%N";
            GOMUKS_CONFIG_HOME = lib.mkDefault "%S/%N";
            GOMUKS_DATA_HOME = lib.mkDefault "%S/%N";
            GOMUKS_LOGS_HOME = lib.mkDefault "%S/%N";
            GOMUKS_CACHE_HOME = lib.mkDefault "%C/%N";
            GOMUKS_TMPDIR = lib.mkDefault "%C/%N";
          };

          preStart = ''
            test -f "$GOMUKS_CONFIG_HOME/config-nixos.yaml" && rm -f "$GOMUKS_CONFIG_HOME/config-nixos.yaml"

            ${lib.getExe pkgs.systemd-credsubst} \
              --copy-if-no-creds \
              --input "${settingsFile}" \
              --output "$GOMUKS_CONFIG_HOME/config-nixos.yaml"

            if [ -f "$GOMUKS_CONFIG_HOME/config.yaml" ];
            then
              ${lib.getExe pkgs.yq-go} -i ". *= load(\"$GOMUKS_CONFIG_HOME/config-nixos.yaml\")" "$GOMUKS_CONFIG_HOME/config.yaml"
            else
              cp "$GOMUKS_CONFIG_HOME/config-nixos.yaml" "$GOMUKS_CONFIG_HOME/config.yaml"
            fi
          '';

          serviceConfig = {
            DynamicUser = true;

            StateDirectory = "gomuks-${name}";
            CacheDirectory = "gomuks-${name}";

            ExecStart = lib.getExe cfg.package;

            ProtectSystem = "full";
            ProtectControlGroups = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            LockPersonality = true;

            DevicePolicy = "strict";
            DeviceAllow = [ "/dev/stdin r" ];

            SystemCallArchitectures = "native";
            MemoryDenyWriteExecute = true;

            NoNewPrivileges = true;
            PrivateTmp = true;
            PrivateDevices = true;
            UMask = "077";

            RestrictAddressFamilies = "AF_INET AF_INET6";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;

            RemoveIPC = true;
            PrivateIPC = true;

            SystemCallFilter = [
              "@system-service"
              "~@resources"
              "~@mount"
              "~@setuid"
              "~@cpu-emulation"
              "~@debug"
              "~@keyring"
              "~@obsolete"
              "~@pkey"
              "setrlimit"
            ];
          };
        }
      ))
    );
  };

  meta.maintainers = with lib.maintainers; [
    zaphyra
  ];

}
