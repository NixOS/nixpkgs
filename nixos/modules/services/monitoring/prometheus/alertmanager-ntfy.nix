{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.alertmanager-ntfy;

  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "settings.yml" cfg.settings;

  configsArg = lib.concatStringsSep "," (
    [ settingsFile ] ++ lib.imap0 (i: _: "%d/config-${toString i}.yml") cfg.extraConfigFiles
  );
in

{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.prometheus.alertmanager-ntfy = {
    enable = lib.mkEnableOption "alertmanager-ntfy";

    package = lib.mkPackageOption pkgs "alertmanager-ntfy" { };

    settings = lib.mkOption {
      description = ''
        Configuration of alertmanager-ntfy.
        See <https://github.com/alexbakker/alertmanager-ntfy> for more information.
      '';
      default = { };

      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          http.addr = lib.mkOption {
            type = lib.types.str;
            description = "The address to listen on.";
            default = "127.0.0.1:8000";
            example = ":8000";
          };

          ntfy = {
            baseurl = lib.mkOption {
              type = lib.types.str;
              description = "The base URL of the ntfy.sh instance.";
              example = "https://ntfy.sh";
            };

            notification = {
              topic = lib.mkOption {
                type = lib.types.str;
                description = ''
                  __Note:__ when using ntfy.sh and other public instances
                  it is recommended to set this option to an empty string and set the actual topic via
                  [](#opt-services.prometheus.alertmanager-ntfy.extraConfigFiles) since
                  the `topic` in `ntfy.sh` is essentially a password.

                  The topic to which alerts should be published.
                  Can either be a hardcoded string or a gval expression that evaluates to a string.
                '';
                example = "alertmanager";
              };

              priority = lib.mkOption {
                type = lib.types.str;
                description = ''
                  The ntfy.sh message priority (see <https://docs.ntfy.sh/publish/#message-priority> for more information).
                  Can either be a hardcoded string or a gval expression that evaluates to a string.
                '';
                default = ''status == "firing" ? "high" : "default"'';
              };

              tags = lib.mkOption {
                type = lib.types.listOf (
                  lib.types.submodule {
                    options = {
                      tag = lib.mkOption {
                        type = lib.types.str;
                        description = ''
                          The tag to add.
                          See <https://docs.ntfy.sh/emojis> for a list of all supported emojis.
                        '';
                        example = "rotating_light";
                      };

                      condition = lib.mkOption {
                        type = lib.types.nullOr lib.types.str;
                        description = ''
                          The condition under which this tag should be added.
                          Tags with no condition are always included.
                        '';
                        default = null;
                        example = ''status == "firing"'';
                      };
                    };
                  }
                );
                description = ''
                  Tags to add to ntfy.sh messages.
                  See <https://docs.ntfy.sh/publish/#tags-emojis> for more information.
                '';
                default = [
                  {
                    tag = "green_circle";
                    condition = ''status == "resolved"'';
                  }
                  {
                    tag = "red_circle";
                    condition = ''status == "firing"'';
                  }
                ];
              };

              templates = {
                title = lib.mkOption {
                  type = lib.types.str;
                  description = "The ntfy.sh message title template.";
                  default = ''
                    {{ if eq .Status "resolved" }}Resolved: {{ end }}{{ index .Annotations "summary" }}
                  '';
                };

                description = lib.mkOption {
                  type = lib.types.str;
                  description = "The ntfy.sh message description template.";
                  default = ''
                    {{ index .Annotations "description" }}
                  '';
                };
              };
            };
          };
        };
      };
    };

    extraConfigFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/alertmanager-ntfy.yml" ];
      description = ''
        Config files to merge into the settings defined in [](#opt-services.prometheus.alertmanager-ntfy.settings).
        This is useful to avoid putting secrets into the Nix store.
        See <https://github.com/alexbakker/alertmanager-ntfy> for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.alertmanager-ntfy = {
      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        User = "alertmanager-ntfy";
        Group = "alertmanager-ntfy";
        DynamicUser = true;

        LoadCredential = lib.imap0 (i: path: "config-${toString i}.yml:${path}") cfg.extraConfigFiles;

        ExecStart = "${lib.getExe cfg.package} --configs ${configsArg}";

        Restart = "always";
        RestartSec = 5;

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ];
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
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };
}
