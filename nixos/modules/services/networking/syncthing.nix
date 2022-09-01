{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.syncthing;
  opt = options.services.syncthing;
  defaultUser = "syncthing";
  defaultGroup = defaultUser;

  devices = mapAttrsToList (name: device: {
    deviceID = device.id;
    inherit (device) name addresses introducer autoAcceptFolders;
  }) cfg.devices;

  folders = mapAttrsToList ( _: folder: {
    inherit (folder) path id label type;
    devices = map (device: { deviceId = cfg.devices.${device}.id; }) folder.devices;
    rescanIntervalS = folder.rescanInterval;
    fsWatcherEnabled = folder.watch;
    fsWatcherDelayS = folder.watchDelay;
    ignorePerms = folder.ignorePerms;
    ignoreDelete = folder.ignoreDelete;
    versioning = folder.versioning;
  }) (filterAttrs (
    _: folder:
    folder.enable
  ) cfg.folders);

  updateConfig = pkgs.writers.writeDash "merge-syncthing-config" ''
    set -efu

    # be careful not to leak secrets in the filesystem or in process listings

    umask 0077

    # get the api key by parsing the config.xml
    while
        ! ${pkgs.libxml2}/bin/xmllint \
            --xpath 'string(configuration/gui/apikey)' \
            ${cfg.configDir}/config.xml \
            >"$RUNTIME_DIRECTORY/api_key"
    do sleep 1; done

    (printf "X-API-Key: "; cat "$RUNTIME_DIRECTORY/api_key") >"$RUNTIME_DIRECTORY/headers"

    curl() {
        ${pkgs.curl}/bin/curl -sSLk -H "@$RUNTIME_DIRECTORY/headers" \
            --retry 1000 --retry-delay 1 --retry-all-errors \
            "$@"
    }

    # query the old config
    old_cfg=$(curl ${cfg.guiAddress}/rest/config)

    # generate the new config by merging with the NixOS config options
    new_cfg=$(printf '%s\n' "$old_cfg" | ${pkgs.jq}/bin/jq -c '. * {
        "devices": (${builtins.toJSON devices}${optionalString (! cfg.overrideDevices) " + .devices"}),
        "folders": (${builtins.toJSON folders}${optionalString (! cfg.overrideFolders) " + .folders"})
    } * ${builtins.toJSON cfg.extraOptions}')

    # send the new config
    curl -X PUT -d "$new_cfg" ${cfg.guiAddress}/rest/config

    # restart Syncthing if required
    if curl ${cfg.guiAddress}/rest/config/restart-required |
       ${pkgs.jq}/bin/jq -e .requiresRestart > /dev/null; then
        curl -X POST ${cfg.guiAddress}/rest/system/restart
    fi
  '';
in {
  ###### interface
  options = {
    services.syncthing = {

      enable = mkEnableOption
        "Syncthing, a self-hosted open-source alternative to Dropbox and Bittorrent Sync";

      cert = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = mdDoc ''
          Path to the `cert.pem` file, which will be copied into Syncthing's
          [configDir](#opt-services.syncthing.configDir).
        '';
      };

      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = mdDoc ''
          Path to the `key.pem` file, which will be copied into Syncthing's
          [configDir](#opt-services.syncthing.configDir).
        '';
      };

      overrideDevices = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc ''
          Whether to delete the devices which are not configured via the
          [devices](#opt-services.syncthing.devices) option.
          If set to `false`, devices added via the web
          interface will persist and will have to be deleted manually.
        '';
      };

      devices = mkOption {
        default = {};
        description = mdDoc ''
          Peers/devices which Syncthing should communicate with.

          Note that you can still add devices manually, but those changes
          will be reverted on restart if [overrideDevices](#opt-services.syncthing.overrideDevices)
          is enabled.
        '';
        example = {
          bigbox = {
            id = "7CFNTQM-IMTJBHJ-3UWRDIU-ZGQJFR6-VCXZ3NB-XUH3KZO-N52ITXR-LAIYUAU";
            addresses = [ "tcp://192.168.0.10:51820" ];
          };
        };
        type = types.attrsOf (types.submodule ({ name, ... }: {
          options = {

            name = mkOption {
              type = types.str;
              default = name;
              description = lib.mdDoc ''
                The name of the device.
              '';
            };

            addresses = mkOption {
              type = types.listOf types.str;
              default = [];
              description = lib.mdDoc ''
                The addresses used to connect to the device.
                If this is left empty, dynamic configuration is attempted.
              '';
            };

            id = mkOption {
              type = types.str;
              description = mdDoc ''
                The device ID. See <https://docs.syncthing.net/dev/device-ids.html>.
              '';
            };

            introducer = mkOption {
              type = types.bool;
              default = false;
              description = mdDoc ''
                Whether the device should act as an introducer and be allowed
                to add folders on this computer.
                See <https://docs.syncthing.net/users/introducer.html>.
              '';
            };

            autoAcceptFolders = mkOption {
              type = types.bool;
              default = false;
              description = mdDoc ''
                Automatically create or share folders that this device advertises at the default path.
                See <https://docs.syncthing.net/users/config.html?highlight=autoaccept#config-file-format>.
              '';
            };

          };
        }));
      };

      overrideFolders = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc ''
          Whether to delete the folders which are not configured via the
          [folders](#opt-services.syncthing.folders) option.
          If set to `false`, folders added via the web
          interface will persist and will have to be deleted manually.
        '';
      };

      folders = mkOption {
        default = {};
        description = mdDoc ''
          Folders which should be shared by Syncthing.

          Note that you can still add folders manually, but those changes
          will be reverted on restart if [overrideFolders](#opt-services.syncthing.overrideFolders)
          is enabled.
        '';
        example = literalExpression ''
          {
            "/home/user/sync" = {
              id = "syncme";
              devices = [ "bigbox" ];
            };
          }
        '';
        type = types.attrsOf (types.submodule ({ name, ... }: {
          options = {

            enable = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Whether to share this folder.
                This option is useful when you want to define all folders
                in one place, but not every machine should share all folders.
              '';
            };

            path = mkOption {
              type = types.str;
              default = name;
              description = lib.mdDoc ''
                The path to the folder which should be shared.
              '';
            };

            id = mkOption {
              type = types.str;
              default = name;
              description = lib.mdDoc ''
                The ID of the folder. Must be the same on all devices.
              '';
            };

            label = mkOption {
              type = types.str;
              default = name;
              description = lib.mdDoc ''
                The label of the folder.
              '';
            };

            devices = mkOption {
              type = types.listOf types.str;
              default = [];
              description = mdDoc ''
                The devices this folder should be shared with. Each device must
                be defined in the [devices](#opt-services.syncthing.devices) option.
              '';
            };

            versioning = mkOption {
              default = null;
              description = mdDoc ''
                How to keep changed/deleted files with Syncthing.
                There are 4 different types of versioning with different parameters.
                See <https://docs.syncthing.net/users/versioning.html>.
              '';
              example = literalExpression ''
                [
                  {
                    versioning = {
                      type = "simple";
                      params.keep = "10";
                    };
                  }
                  {
                    versioning = {
                      type = "trashcan";
                      params.cleanoutDays = "1000";
                    };
                  }
                  {
                    versioning = {
                      type = "staggered";
                      fsPath = "/syncthing/backup";
                      params = {
                        cleanInterval = "3600";
                        maxAge = "31536000";
                      };
                    };
                  }
                  {
                    versioning = {
                      type = "external";
                      params.versionsPath = pkgs.writers.writeBash "backup" '''
                        folderpath="$1"
                        filepath="$2"
                        rm -rf "$folderpath/$filepath"
                      ''';
                    };
                  }
                ]
              '';
              type = with types; nullOr (submodule {
                options = {
                  type = mkOption {
                    type = enum [ "external" "simple" "staggered" "trashcan" ];
                    description = mdDoc ''
                      The type of versioning.
                      See <https://docs.syncthing.net/users/versioning.html>.
                    '';
                  };
                  fsPath = mkOption {
                    default = "";
                    type = either str path;
                    description = mdDoc ''
                      Path to the versioning folder.
                      See <https://docs.syncthing.net/users/versioning.html>.
                    '';
                  };
                  params = mkOption {
                    type = attrsOf (either str path);
                    description = mdDoc ''
                      The parameters for versioning. Structure depends on
                      [versioning.type](#opt-services.syncthing.folders._name_.versioning.type).
                      See <https://docs.syncthing.net/users/versioning.html>.
                    '';
                  };
                };
              });
            };

            rescanInterval = mkOption {
              type = types.int;
              default = 3600;
              description = lib.mdDoc ''
                How often the folder should be rescanned for changes.
              '';
            };

            type = mkOption {
              type = types.enum [ "sendreceive" "sendonly" "receiveonly" ];
              default = "sendreceive";
              description = lib.mdDoc ''
                Whether to only send changes for this folder, only receive them
                or both.
              '';
            };

            watch = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Whether the folder should be watched for changes by inotify.
              '';
            };

            watchDelay = mkOption {
              type = types.int;
              default = 10;
              description = lib.mdDoc ''
                The delay after an inotify event is triggered.
              '';
            };

            ignorePerms = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Whether to ignore permission changes.
              '';
            };

            ignoreDelete = mkOption {
              type = types.bool;
              default = false;
              description = mdDoc ''
                Whether to skip deleting files that are deleted by peers.
                See <https://docs.syncthing.net/advanced/folder-ignoredelete.html>.
              '';
            };
          };
        }));
      };

      extraOptions = mkOption {
        type = types.addCheck (pkgs.formats.json {}).type isAttrs;
        default = {};
        description = mdDoc ''
          Extra configuration options for Syncthing.
          See <https://docs.syncthing.net/users/config.html>.
        '';
        example = {
          options.localAnnounceEnabled = false;
          gui.theme = "black";
        };
      };

      guiAddress = mkOption {
        type = types.str;
        default = "127.0.0.1:8384";
        description = lib.mdDoc ''
          The address to serve the web interface at.
        '';
      };

      systemService = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to auto-launch Syncthing as a system service.
        '';
      };

      user = mkOption {
        type = types.str;
        default = defaultUser;
        example = "yourUser";
        description = mdDoc ''
          The user to run Syncthing as.
          By default, a user named `${defaultUser}` will be created.
        '';
      };

      group = mkOption {
        type = types.str;
        default = defaultGroup;
        example = "yourGroup";
        description = mdDoc ''
          The group to run Syncthing under.
          By default, a group named `${defaultGroup}` will be created.
        '';
      };

      all_proxy = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "socks5://address.com:1234";
        description = mdDoc ''
          Overwrites the all_proxy environment variable for the Syncthing process to
          the given value. This is normally used to let Syncthing connect
          through a SOCKS5 proxy server.
          See <https://docs.syncthing.net/users/proxying.html>.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/syncthing";
        example = "/home/yourUser";
        description = lib.mdDoc ''
          The path where synchronised directories will exist.
        '';
      };

      configDir = let
        cond = versionAtLeast config.system.stateVersion "19.03";
      in mkOption {
        type = types.path;
        description = lib.mdDoc ''
          The path where the settings and keys will exist.
        '';
        default = cfg.dataDir + optionalString cond "/.config/syncthing";
        defaultText = literalMD ''
          * if `stateVersion >= 19.03`:

                config.${opt.dataDir} + "/.config/syncthing"
          * otherwise:

                config.${opt.dataDir}
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--reset-deltas" ];
        description = lib.mdDoc ''
          Extra flags passed to the syncthing command in the service definition.
        '';
      };

      openDefaultPorts = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = lib.mdDoc ''
          Whether to open the default ports in the firewall: TCP/UDP 22000 for transfers
          and UDP 21027 for discovery.

          If multiple users are running Syncthing on this machine, you will need
          to manually open a set of ports for each instance and leave this disabled.
          Alternatively, if you are running only a single instance on this machine
          using the default ports, enable this.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.syncthing;
        defaultText = literalExpression "pkgs.syncthing";
        description = lib.mdDoc ''
          The Syncthing package to use.
        '';
      };
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "syncthing" "useInotify" ] ''
      This option was removed because Syncthing now has the inotify functionality included under the name "fswatcher".
      It can be enabled on a per-folder basis through the web interface.
    '')
  ] ++ map (o:
    mkRenamedOptionModule [ "services" "syncthing" "declarative" o ] [ "services" "syncthing" o ]
  ) [ "cert" "key" "devices" "folders" "overrideDevices" "overrideFolders" "extraOptions"];

  ###### implementation

  config = mkIf cfg.enable {

    networking.firewall = mkIf cfg.openDefaultPorts {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 21027 22000 ];
    };

    systemd.packages = [ pkgs.syncthing ];

    users.users = mkIf (cfg.systemService && cfg.user == defaultUser) {
      ${defaultUser} =
        { group = cfg.group;
          home  = cfg.dataDir;
          createHome = true;
          uid = config.ids.uids.syncthing;
          description = "Syncthing daemon user";
        };
    };

    users.groups = mkIf (cfg.systemService && cfg.group == defaultGroup) {
      ${defaultGroup}.gid =
        config.ids.gids.syncthing;
    };

    systemd.services = {
      syncthing = mkIf cfg.systemService {
        description = "Syncthing service";
        after = [ "network.target" ];
        environment = {
          STNORESTART = "yes";
          STNOUPGRADE = "yes";
          inherit (cfg) all_proxy;
        } // config.networking.proxy.envVars;
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "on-failure";
          SuccessExitStatus = "2 3 4";
          RestartForceExitStatus="3 4";
          User = cfg.user;
          Group = cfg.group;
          ExecStartPre = mkIf (cfg.cert != null || cfg.key != null)
            "+${pkgs.writers.writeBash "syncthing-copy-keys" ''
              install -dm700 -o ${cfg.user} -g ${cfg.group} ${cfg.configDir}
              ${optionalString (cfg.cert != null) ''
                install -Dm400 -o ${cfg.user} -g ${cfg.group} ${toString cfg.cert} ${cfg.configDir}/cert.pem
              ''}
              ${optionalString (cfg.key != null) ''
                install -Dm400 -o ${cfg.user} -g ${cfg.group} ${toString cfg.key} ${cfg.configDir}/key.pem
              ''}
            ''}"
          ;
          ExecStart = ''
            ${cfg.package}/bin/syncthing \
              -no-browser \
              -gui-address=${cfg.guiAddress} \
              -home=${cfg.configDir} ${escapeShellArgs cfg.extraFlags}
          '';
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          CapabilityBoundingSet = [
            "~CAP_SYS_PTRACE" "~CAP_SYS_ADMIN"
            "~CAP_SETGID" "~CAP_SETUID" "~CAP_SETPCAP"
            "~CAP_SYS_TIME" "~CAP_KILL"
          ];
        };
      };
      syncthing-init = mkIf (
        cfg.devices != {} || cfg.folders != {} || cfg.extraOptions != {}
      ) {
        description = "Syncthing configuration updater";
        requisite = [ "syncthing.service" ];
        after = [ "syncthing.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          User = cfg.user;
          RemainAfterExit = true;
          RuntimeDirectory = "syncthing-init";
          Type = "oneshot";
          ExecStart = updateConfig;
        };
      };

      syncthing-resume = {
        wantedBy = [ "suspend.target" ];
      };
    };
  };
}
