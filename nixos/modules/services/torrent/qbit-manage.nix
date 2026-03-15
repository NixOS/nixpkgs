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
    optionals
    ;
  inherit (lib.types)
    str
    path
    int
    listOf
    attrsOf
    submodule
    nullOr
    either
    port
    addCheck
    ;
in
{
  options.services.qbit-manage = {
    enable = mkEnableOption "Enable qbit-manage.";

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
        See https://github.com/StuffAnThings/qbit_manage/wiki/Config-Setup for more information.

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
                    Root downloads directory used to check for orphaned files, noHL, and remove unregistered.
                    This directory is where you place all your downloads.
                    This will need to be how qB views the directory where it places the downloads.
                    This is required if you're using qbit-manage and/or qBittorrent within a container.
                  '';
                };

                remote_dir = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of docker host mapping of root_dir, this must be set if you're running qbit-manage locally (not required if running qbit-manage in a container) and qBittorrent/cross_seed is in a docker.
                    Essentially this is where your downloads are being kept on the host.
                  '';
                };

                recycle_bin = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of the RecycleBin folder.
                    Default location is set to remote_dir/.RecycleBin.
                    All files in this folder will be cleaned up based on your recycle bin settings.
                  '';
                };

                torrents_dir = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of the your qbittorrent torrents directory.
                    Required for save_torrents attribute in recyclebin /qbittorrent/data/BT_backup.
                  '';
                };

                orphaned_dir = mkOption {
                  type = nullOr path;
                  default = null;
                  description = ''
                    Path of the Orphaned Directory folder.
                    Default location is set to remote_dir/orphaned_data.
                    All files in this folder will be cleaned up based on your orphaned data settings.
                    Only orphaned data shall exist in this path as all contents are considered disposable.
                  '';
                };
              };
            });
          };

          cat = mkOption {
            description = "This section defines the categories that you are currently using and the save path's that are associated with them.";
            type = attrsOf path;
          };

          tracker = mkOption {
            description = "This section defines the tags used based upon the tracker's URL.";
            type = attrsOf (submodule {
              options = {
                tag = mkOption {
                  type = either str (listOf str);
                  description = "The tracker tag or additional list of tags defined.";
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
        See https://github.com/StuffAnThings/qbit_manage/wiki/Commands for more information.
      '';
      default = { };
      type = submodule {
        options = {
          schedule = mkOption {
            type = nullOr int;
            default = null;
            description = "Schedule to run every x minutes. If not set it will only run once then exit.";
          };

          startupDelay = mkOption {
            type = int;
            default = 0;
            description = "Set delay in seconds on the first run of a schedule";
          };

          recheck = mkEnableOption "Recheck paused torrents sorted by lowest size. Resume if Completed.";
          catUpdate = mkEnableOption "Use this option to update your categories or switch between them.";
          tagUpdate = mkEnableOption "Use this if you would like to update your tags and/or set seed goals/limit upload speed by tag.";
          remUnregistered = mkEnableOption "Use this if you would like to remove unregistered torrents.";
          tagTrackerError = mkEnableOption "Use this if you would like to tag torrents that do not have a working tracker.";
          remOrphaned = mkEnableOption "Use this if you would like to remove orphaned files from your 'root_dir' directory that are not referenced by any torrents.";
          tagNoHardLinks = mkEnableOption "Use this to tag torrents where the largest file does not have any hardlinks associated with any of the files outside of your qbit-manage root directory.";
          shareLimits = mkEnableOption "Control how torrent share limits are set depending on the priority of your grouping.";
          skipCleanup = mkEnableOption "Use this to skip emptying the recycle Bin folder and Orphaned directory.";
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
      tmpfiles.settings.qbit-manage."${cfg.dataDir}".d = {
        inherit (cfg) user group;
        mode = "755";
      };

      services."qbit-manage" = {
        description = "Tool to manage tasks for qbittorrent";
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        preStart = mkIf (cfg.config != null) ''
          install -D -m 600 -o '${cfg.user}' -g '${cfg.group}' '${createYAMLConfig cfg.config}' '${cfg.dataDir}/config.yml'
        '';
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          ExecStart =
            let
              webServerFlags =
                let
                  ws = cfg.webServer;
                in
                if ws.enable then
                  [
                    "--web-server"
                    "--port ${toString ws.port}"
                  ]
                  ++ optionals (ws.host != null) [
                    "--host ${ws.host}"
                  ]
                  ++ optionals (ws.baseURL != null) [
                    "--base-url ${ws.baseURL}"
                  ]
                else
                  [ "--web-server=False" ];

              commandFlags =
                let
                  cmds = cfg.commands;
                in
                [
                  "--startup-delay ${toString cmds.startupDelay}"
                ]
                ++ optionals (cmds.schedule == null) [
                  "--run"
                ]
                ++ optionals (cmds.schedule != null) [
                  "--schedule ${toString cmds.schedule}"
                ]
                ++ optionals cmds.recheck [
                  "--recheck"
                ]
                ++ optionals cmds.catUpdate [
                  "--cat-update"
                ]
                ++ optionals cmds.tagUpdate [
                  "--tag-update"
                ]
                ++ optionals cmds.remUnregistered [
                  "--rem-unregistered"
                ]
                ++ optionals cmds.tagTrackerError [
                  "--tag-tracker-error"
                ]
                ++ optionals cmds.remOrphaned [
                  "--rem-orphaned"
                ]
                ++ optionals cmds.tagNoHardLinks [
                  "--tag-nohardlinks"
                ]
                ++ optionals cmds.shareLimits [
                  "--share-limits"
                ]
                ++ optionals cmds.skipCleanup [
                  "--skip-cleanup"
                ];

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
