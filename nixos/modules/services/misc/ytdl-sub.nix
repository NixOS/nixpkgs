{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.ytdl-sub;

  settingsFormat = pkgs.formats.yaml { };
in
{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.ytdl-sub = {
    package = lib.mkPackageOption pkgs "ytdl-sub" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "ytdl-sub";
      description = "User account under which ytdl-sub runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "ytdl-sub";
      description = "Group under which ytdl-sub runs.";
    };

    instances = lib.mkOption {
      default = { };
      description = "Configuration for ytdl-sub instances.";
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              enable = lib.mkEnableOption "ytdl-sub instance";

              schedule = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                description = "How often to run ytdl-sub. See {manpage}`systemd.time(7)` for the format.";
                default = null;
                example = "0/6:0";
              };

              config = lib.mkOption {
                type = settingsFormat.type;
                description = "Configuration for ytdl-sub. See <https://ytdl-sub.readthedocs.io/en/latest/config_reference/config_yaml.html> for more information.";
                default = { };
                example = {
                  presets."YouTube Playlist" = {
                    download = "{subscription_value}";
                    output_options = {
                      output_directory = "YouTube";
                      file_name = "{channel}/{playlist_title}/{playlist_index_padded}_{title}.{ext}";
                      maintain_download_archive = true;
                    };
                  };
                };
              };

              subscriptions = lib.mkOption {
                type = settingsFormat.type;
                description = "Subscriptions for ytdl-sub. See <https://ytdl-sub.readthedocs.io/en/latest/config_reference/subscription_yaml.html> for more information.";
                default = { };
                example = {
                  "YouTube Playlist" = {
                    "Some Playlist" = "https://www.youtube.com/playlist?list=...";
                  };
                };
              };
            };

            config = {
              config.configuration.working_directory = "/run/ytdl-sub/${utils.escapeSystemdPath name}";
            };
          }
        )
      );
    };
  };

  config = lib.mkIf (cfg.instances != { }) {
    systemd.services =
      let
        mkService =
          name: instance:
          let
            configFile = settingsFormat.generate "config.yaml" instance.config;
            subscriptionsFile = settingsFormat.generate "subscriptions.yaml" instance.subscriptions;
          in
          lib.nameValuePair "ytdl-sub-${utils.escapeSystemdPath name}" {
            inherit (instance) enable;

            wants = [ "network-online.target" ];
            after = [ "network-online.target" ];

            startAt = lib.optional (instance.schedule != null) instance.schedule;

            serviceConfig = {
              User = cfg.user;
              Group = cfg.group;

              RuntimeDirectory = "ytdl-sub/${utils.escapeSystemdPath name}";
              StateDirectory = "ytdl-sub/${utils.escapeSystemdPath name}";
              WorkingDirectory = "/var/lib/ytdl-sub/${utils.escapeSystemdPath name}";

              ExecStart = "${lib.getExe cfg.package} --config ${configFile} sub ${subscriptionsFile}";

              # Hardening
              CapabilityBoundingSet = [ "" ];
              DeviceAllow = [ "" ];
              LockPersonality = true;
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
              RestrictAddressFamilies = [
                "AF_INET"
                "AF_INET6"
                "AF_UNIX"
              ];
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              SystemCallArchitectures = "native";
            };
          };
      in
      lib.mapAttrs' mkService cfg.instances;

    users.users = lib.mkIf (cfg.user == "ytdl-sub") {
      ytdl-sub = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "ytdl-sub") {
      ytdl-sub = { };
    };
  };
}
