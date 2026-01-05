{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.qbit-manage;
  yaml = pkgs.formats.yaml { };
  createYAMLConfig =
    config:
    pkgs.runCommand "config.yml" { } ''
      # Need to run sed to remove the quotes around !ENV values
      # otherwise qbit-manage will not interpret them as environment variables
      sed -E "s/'(!ENV) (.*)'/\1 \2/g" '${yaml.generate "tmp" config}' > $out
    '';
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    strings
    optional
    ;
  inherit (lib.types)
    str
    path
    listOf
    attrsOf
    submodule
    nullOr
    either
    port
    addCheck
    ints
    bool
    ;
in
{
  options.services.qbit-manage = {
    enable = mkEnableOption "qbit-manage";

    package = mkPackageOption pkgs "qbit-manage" { };

    user = mkOption {
      type = str;
      default = "qbit-manage";
      description = "User account under which qbit-manage runs.";
    };

    group = mkOption {
      type = str;
      default = "qbit-manage";
      description = "Group under which qbit-manage runs.";
    };

    dataDir = mkOption {
      type = path;
      default = "/var/lib/qbit-manage";
      description = "Directory to store qbit-manage data files.";
    };

    environmentFile = mkOption {
      type = nullOr path;
      default = null;
      description = "Path to an environment file to load environment variables from.";
    };

    config = mkOption {
      description = ''
        qbit-manage configuration. Will be translated into YAML.
        For environment variable support, use '!ENV VAR_NAME' as the value.
        See <https://github.com/StuffAnThings/qbit_manage/wiki/Config-Setup> for more information.

        Leave unset to configure without nix.
      '';
      default = null;
      type = nullOr (submodule {
        freeformType = yaml.type;
        options = {
          qbt = mkOption {
            description = "This section defines your qBittorrent instance";
            type = submodule {
              options = {
                host = mkOption {
                  type = str;
                  default = "localhost:8080";
                  description = "IP address of your qBittorrent installation.";
                };

                user = mkOption {
                  type = nullOr str;
                  description = "The user name of your qBittorrent webUI.";
                };

                pass = mkOption {
                  type = nullOr (addCheck str (p: strings.hasPrefix "!ENV " p));
                  description = "The password of your qBbittorrent webUI.";
                };
              };
            };
          };

          directory = mkOption {
            description = "This section defines the directories that qbit-manage will be looking into for various parts of the script.";
            default = null;
            type = nullOr (submodule {
              options = {
                root_dir = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Root downloads directory where you place all your downloads.
                    Used to check for orphaned files, hard links, and unregistered torrents.
                  '';
                };

                recycle_bin = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of the RecycleBin folder.
                    All files in this folder will be cleaned up based on your recycle bin settings.
                  '';
                };

                torrents_dir = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of the qBittorrent BT_backup directory.
                  '';
                };

                orphaned_dir = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of the Orphaned Directory folder.
                    All files in this folder will be cleaned up based on your orphaned data settings.
                  '';
                };
              };
            });
          };

          cat = mkOption {
            description = "A mapping of categories and their associated paths.";
            type = attrsOf path;
            example = lib.literalExpression ''
              {
                sonarr = "/donwloads/completed/sonarr";
                radaarr = "/donwloads/completed/radaarr";
              }
            '';
          };

          tracker = mkOption {
            description = "Tags based upon the tracker's URL.";
            type = attrsOf (submodule {
              options = {
                tag = mkOption {
                  type = either str (listOf str);
                  description = "The tracker tag or additional list of tags.";
                };

                cat = mkOption {
                  type = nullOr str;
                  default = null;
                  description = ''
                    Set the category based on tracker URL.
                    This category option takes priority over the category defined in cat.
                  '';
                };

                notifiarr = mkOption {
                  type = nullOr str;
                  default = null;
                  description = ''
                    Set this to the notifiarr react name.
                    This is used to add indexer reactions to the notifications sent by Notifiarr.
                  '';
                };
              };
            });
          };
        };
      });
    };

    commands = mkOption {
      description = ''
        The commands that you want qbm to execute.
        See <https://github.com/StuffAnThings/qbit_manage/wiki/Commands> for more information.
      '';
      default = { };
      type = submodule {
        options = {
          schedule = mkOption {
            type = nullOr ints.positive;
            default = null;
            description = "Schedule to run every x minutes. If not set it will only run once then exit.";
          };

          startupDelay = mkOption {
            type = nullOr ints.positive;
            default = null;
            description = "Set delay in seconds on the first run of a schedule";
          };

          recheck = mkOption {
            type = bool;
            default = false;
            description = "Whether to recheck paused torrents sorted by lowest size. Resume if Completed.";
          };
          catUpdate = mkOption {
            type = bool;
            default = false;
            description = "Whether to update your categories.";
          };
          tagUpdate = mkOption {
            type = bool;
            default = false;
            description = "Whether to update your tags and/or set seed goals/limit upload speed by tag.";
          };
          remUnregistered = mkOption {
            type = bool;
            default = false;
            description = "Whether to remove unregistered torrents.";
          };
          tagTrackerError = mkOption {
            type = bool;
            default = false;
            description = "Whether to tag torrents that do not have a working tracker.";
          };
          remOrphaned = mkOption {
            type = bool;
            default = false;
            description = "Whether to remove orphaned files from your 'root_dir' directory that are not referenced by any torrents.";
          };
          tagNoHardLinks = mkOption {
            type = bool;
            default = false;
            description = "Whether to tag torrents where the largest file does not have any hardlinks associated with any of the files outside of your qbit-manage root directory.";
          };
          shareLimits = mkOption {
            type = bool;
            default = false;
            description = "Whether to control how torrent share limits are set depending on the priority of your grouping.";
          };
          skipCleanup = mkOption {
            type = bool;
            default = false;
            description = "Whether to skip emptying the recycle Bin folder and Orphaned directory.";
          };
        };
      };
    };

    webServer = mkOption {
      description = "Web server configuration.";
      default = { };
      type = submodule {
        options = {
          enable = mkEnableOption "Enable the web server.";

          port = mkOption {
            type = port;
            default = 8080;
            description = "Port number for the web server.";
          };

          host = mkOption {
            type = nullOr str;
            default = null;
            description = "Hostname for the web server.";
          };

          baseURL = mkOption {
            type = nullOr str;
            default = null;
            description = "Base URL path for the web UI (e.g., '/qbit-manage').";
          };

          openFirewall = mkEnableOption "Open the firewall for webUI.";
        };
      };
    };

    extraArgs = mkOption {
      type = listOf str;
      default = [ ];
      description = "Extra command line arguments to pass to qbit-manage.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          (cfg.config == null)
          || (
            (!cfg.commands.remOrphaned) && (!cfg.commands.tagNoHardLinks) && (!cfg.commands.remUnregistered)
          )
          || (cfg.config.directory != null && cfg.config.directory.root_dir != null);
        message = "services.qbit-manage.config.directory.root_dir must be set when using remOrphaned, tagNoHardLinks or remUnregistered commands.";
      }
    ];

    networking.firewall.allowedTCPPorts = mkIf (cfg.webServer.enable && cfg.webServer.openFirewall) [
      cfg.webServer.port
    ];

    users = {
      users = mkIf (cfg.user == "qbit-manage") {
        qbit-manage = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };

      groups = mkIf (cfg.group == "qbit-manage") { qbit-manage = { }; };
    };

    systemd = {
      tmpfiles.settings.qbit-manage = {
        "${cfg.dataDir}".d = {
          inherit (cfg) user group;
          mode = "0755";
        };
        "${cfg.dataDir}/config.yml"."C+" = mkIf (cfg.config != null) {
          inherit (cfg) user group;
          mode = "0600";
          argument = "${createYAMLConfig cfg.config}";
        };
      };

      services."qbit-manage" = {
        description = "Tool to manage tasks for qBittorrent";
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          ExecStart =
            let
              webServerFlags =
                if cfg.webServer.enable then
                  [
                    "--web-server"
                    "--port ${toString cfg.webServer.port}"
                  ]
                  ++ optional (cfg.webServer.host != null) "--host ${cfg.webServer.host}"
                  ++ optional (cfg.webServer.baseURL != null) "--base-url ${cfg.webServer.baseURL}"
                else
                  [ "--web-server=False" ];

              commandFlags =
                optional (cfg.commands.startupDelay != null) "--startup-delay ${toString cfg.commands.startupDelay}"
                ++ optional (cfg.commands.schedule == null) "--run"
                ++ optional (cfg.commands.schedule != null) "--schedule ${toString cfg.commands.schedule}"
                ++ optional cfg.commands.recheck "--recheck"
                ++ optional cfg.commands.catUpdate "--cat-update"
                ++ optional cfg.commands.tagUpdate "--tag-update"
                ++ optional cfg.commands.remUnregistered "--rem-unregistered"
                ++ optional cfg.commands.tagTrackerError "--tag-tracker-error"
                ++ optional cfg.commands.remOrphaned "--rem-orphaned"
                ++ optional cfg.commands.tagNoHardLinks "--tag-nohardlinks"
                ++ optional cfg.commands.shareLimits "--share-limits"
                ++ optional cfg.commands.skipCleanup "--skip-cleanup";

              flags = [
                "--config-dir ${cfg.dataDir}"
              ]
              ++ webServerFlags
              ++ commandFlags
              ++ cfg.extraArgs;
            in
            "${lib.getExe cfg.package} ${lib.concatStringsSep " " flags}";

          EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;

          # Hardening
          ProtectSystem = "full";
          ProtectHome = true;
          PrivateMounts = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          LockPersonality = true;
          RestrictRealtime = true;
          ProtectClock = true;
          MemoryDenyWriteExecute = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_UNIX"
          ];
          SocketBindDeny = [
            "ipv4:udp"
            "ipv6:udp"
          ];
          CapabilityBoundingSet = [
            "~CAP_BLOCK_SUSPEND"
            "~CAP_BPF"
            "~CAP_IPC_LOCK"
            "~CAP_MKNOD"
            "~CAP_NET_RAW"
            "~CAP_PERFMON"
            "~CAP_SYS_BOOT"
            "~CAP_SYS_CHROOT"
            "~CAP_SYS_MODULE"
            "~CAP_SYS_NICE"
            "~CAP_SYS_PACCT"
            "~CAP_SYS_PTRACE"
            "~CAP_SYS_TIME"
            "~CAP_SYSLOG"
            "~CAP_WAKE_ALARM"
          ];
          SystemCallFilter = [
            "~@aio:EPERM"
            "~@clock:EPERM"
            "~@cpu-emulation:EPERM"
            "~@debug:EPERM"
            "~@keyring:EPERM"
            "~@memlock:EPERM"
            "~@module:EPERM"
            "~@mount:EPERM"
            "~@obsolete:EPERM"
            "~@pkey:EPERM"
            "~@raw-io:EPERM"
            "~@reboot:EPERM"
            "~@resources:EPERM"
            "~@sandbox:EPERM"
            "~@setuid:EPERM"
            "~@swap:EPERM"
            "~@sync:EPERM"
            "~@timer:EPERM"
          ];
        };
      };
    };
  };
  meta.maintainers = with lib.maintainers; [
    flyingpeakock
  ];
}
