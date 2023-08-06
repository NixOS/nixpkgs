{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.syncthing;
  opt = options.services.syncthing;
  defaultUser = "syncthing";
  defaultGroup = defaultUser;
  settingsFormat = pkgs.formats.json { };
  cleanedConfig = converge (filterAttrsRecursive (_: v: v != null && v != {})) cfg.settings;

  devices = mapAttrsToList (_: device: device // {
    deviceID = device.id;
  }) cfg.settings.devices;

  folders = mapAttrsToList (_: folder: folder //
    throwIf (folder?rescanInterval || folder?watch || folder?watchDelay) ''
      The options services.syncthing.settings.folders.<name>.{rescanInterval,watch,watchDelay}
      were removed. Please use, respectively, {rescanIntervalS,fsWatcherEnabled,fsWatcherDelayS} instead.
    '' {
    devices = map (device:
      if builtins.isString device then
        { deviceId = cfg.settings.devices.${device}.id; }
      else
        device
    ) folder.devices;
  }) (filterAttrs (_: folder:
    folder.enable
  ) cfg.settings.folders);

  jq = "${pkgs.jq}/bin/jq";
  updateConfig = pkgs.writers.writeBash "merge-syncthing-config" (''
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
  '' +

  /* Syncthing's rest API for the folders and devices is almost identical.
  Hence we iterate them using lib.pipe and generate shell commands for both at
  the sime time. */
  (lib.pipe {
    # The attributes below are the only ones that are different for devices /
    # folders.
    devs = {
      new_conf_IDs = map (v: v.id) devices;
      GET_IdAttrName = "deviceID";
      override = cfg.overrideDevices;
      conf = devices;
      baseAddress = "${cfg.guiAddress}/rest/config/devices";
    };
    dirs = {
      new_conf_IDs = map (v: v.id) folders;
      GET_IdAttrName = "id";
      override = cfg.overrideFolders;
      conf = folders;
      baseAddress = "${cfg.guiAddress}/rest/config/folders";
    };
  } [
    # Now for each of these attributes, write the curl commands that are
    # identical to both folders and devices.
    (mapAttrs (conf_type: s:
      # We iterate the `conf` list now, and run a curl -X POST command for each, that
      # should update that device/folder only.
      lib.pipe s.conf [
        # Quoting https://docs.syncthing.net/rest/config.html:
        #
        # > PUT takes an array and POST a single object. In both cases if a
        # given folder/device already exists, it’s replaced, otherwise a new
        # one is added.
        #
        # What's not documented, is that using PUT will remove objects that
        # don't exist in the array given. That's why we use here `POST`, and
        # only if s.override == true then we DELETE the relevant folders
        # afterwards.
        (map (new_cfg: ''
          curl -d ${lib.escapeShellArg (builtins.toJSON new_cfg)} -X POST ${s.baseAddress}
        ''))
        (lib.concatStringsSep "\n")
      ]
      /* If we need to override devices/folders, we iterate all currently configured
      IDs, via another `curl -X GET`, and we delete all IDs that are not part of
      the Nix configured list of IDs
      */
      + lib.optionalString s.override ''
        old_conf_${conf_type}_ids="$(curl -X GET ${s.baseAddress} | ${jq} --raw-output '.[].${s.GET_IdAttrName}')"
        for id in ''${old_conf_${conf_type}_ids}; do
          if echo ${lib.concatStringsSep " " s.new_conf_IDs} | grep -q $id; then
            continue
          else
            curl -X DELETE ${s.baseAddress}/$id
          fi
        done
      ''
    ))
    builtins.attrValues
    (lib.concatStringsSep "\n")
  ]) +
  /* Now we update the other settings defined in cleanedConfig which are not
  "folders" or "devices". */
  (lib.pipe cleanedConfig [
    builtins.attrNames
    (lib.subtractLists ["folders" "devices"])
    (map (subOption: ''
      curl -X PUT -d ${lib.escapeShellArg (builtins.toJSON cleanedConfig.${subOption})} \
        ${cfg.guiAddress}/rest/config/${subOption}
    ''))
    (lib.concatStringsSep "\n")
  ]) + ''
    # restart Syncthing if required
    if curl ${cfg.guiAddress}/rest/config/restart-required |
       ${jq} -e .requiresRestart > /dev/null; then
        curl -X POST ${cfg.guiAddress}/rest/system/restart
    fi
  '');
in {
  ###### interface
  options = {
    services.syncthing = {

      enable = mkEnableOption
        (lib.mdDoc "Syncthing, a self-hosted open-source alternative to Dropbox and Bittorrent Sync");

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
          [devices](#opt-services.syncthing.settings.devices) option.
          If set to `false`, devices added via the web
          interface will persist and will have to be deleted manually.
        '';
      };

      overrideFolders = mkOption {
        type = types.bool;
        default = true;
        description = mdDoc ''
          Whether to delete the folders which are not configured via the
          [folders](#opt-services.syncthing.settings.folders) option.
          If set to `false`, folders added via the web
          interface will persist and will have to be deleted manually.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
          options = {
            # global options
            options = mkOption {
              default = {};
              description = mdDoc ''
                The options element contains all other global configuration options
              '';
              type = types.submodule ({ name, ... }: {
                freeformType = settingsFormat.type;
                options = {
                  localAnnounceEnabled = mkOption {
                    type = types.nullOr types.bool;
                    default = null;
                    description = lib.mdDoc ''
                      Whether to send announcements to the local LAN, also use such announcements to find other devices.
                    '';
                  };

                  localAnnouncePort = mkOption {
                    type = types.nullOr types.int;
                    default = null;
                    description = lib.mdDoc ''
                      The port on which to listen and send IPv4 broadcast announcements to.
                    '';
                  };

                  relaysEnabled = mkOption {
                    type = types.nullOr types.bool;
                    default = null;
                    description = lib.mdDoc ''
                      When true, relays will be connected to and potentially used for device to device connections.
                    '';
                  };

                  urAccepted = mkOption {
                    type = types.nullOr types.int;
                    default = null;
                    description = lib.mdDoc ''
                      Whether the user has accepted to submit anonymous usage data.
                      The default, 0, mean the user has not made a choice, and Syncthing will ask at some point in the future.
                      "-1" means no, a number above zero means that that version of usage reporting has been accepted.
                    '';
                  };

                  limitBandwidthInLan = mkOption {
                    type = types.nullOr types.bool;
                    default = null;
                    description = lib.mdDoc ''
                      Whether to apply bandwidth limits to devices in the same broadcast domain as the local device.
                    '';
                  };

                  maxFolderConcurrency = mkOption {
                    type = types.nullOr types.int;
                    default = null;
                    description = lib.mdDoc ''
                      This option controls how many folders may concurrently be in I/O-intensive operations such as syncing or scanning.
                      The mechanism is described in detail in a [separate chapter](https://docs.syncthing.net/advanced/option-max-concurrency.html).
                    '';
                  };
                };
              });
            };

            # device settings
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
                freeformType = settingsFormat.type;
                options = {

                  name = mkOption {
                    type = types.str;
                    default = name;
                    description = lib.mdDoc ''
                      The name of the device.
                    '';
                  };

                  id = mkOption {
                    type = types.str;
                    description = mdDoc ''
                      The device ID. See <https://docs.syncthing.net/dev/device-ids.html>.
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

            # folder settings
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
                freeformType = settingsFormat.type;
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
                    # TODO for release 23.05: allow relative paths again and set
                    # working directory to cfg.dataDir
                    type = types.str // {
                      check = x: types.str.check x && (substring 0 1 x == "/" || substring 0 2 x == "~/");
                      description = types.str.description + " starting with / or ~/";
                    };
                    default = name;
                    description = lib.mdDoc ''
                      The path to the folder which should be shared.
                      Only absolute paths (starting with `/`) and paths relative to
                      the [user](#opt-services.syncthing.user)'s home directory
                      (starting with `~/`) are allowed.
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
                      be defined in the [devices](#opt-services.syncthing.settings.devices) option.
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
                      freeformType = settingsFormat.type;
                      options = {
                        type = mkOption {
                          type = enum [ "external" "simple" "staggered" "trashcan" ];
                          description = mdDoc ''
                            The type of versioning.
                            See <https://docs.syncthing.net/users/versioning.html>.
                          '';
                        };
                      };
                    });
                  };

                  copyOwnershipFromParent = mkOption {
                    type = types.bool;
                    default = false;
                    description = mdDoc ''
                      On Unix systems, tries to copy file/folder ownership from the parent directory (the directory it’s located in).
                      Requires running Syncthing as a privileged user, or granting it additional capabilities (e.g. CAP_CHOWN on Linux).
                    '';
                  };
                };
              }));
            };

          };
        };
        default = {};
        description = mdDoc ''
          Extra configuration options for Syncthing.
          See <https://docs.syncthing.net/users/config.html>.
          Note that this attribute set does not exactly match the documented
          xml format. Instead, this is the format of the json rest api. There
          are slight differences. For example, this xml:
          ```xml
          <options>
            <listenAddress>default</listenAddress>
            <minHomeDiskFree unit="%">1</minHomeDiskFree>
          </options>
          ```
          corresponds to the json:
          ```json
          {
            options: {
              listenAddresses = [
                "default"
              ];
              minHomeDiskFree = {
                unit = "%";
                value = 1;
              };
            };
          }
          ```
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
          By default, a user named `${defaultUser}` will be created whose home
          directory is [dataDir](#opt-services.syncthing.dataDir).
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
    (mkRenamedOptionModule [ "services" "syncthing" "extraOptions" ] [ "services" "syncthing" "settings" ])
    (mkRenamedOptionModule [ "services" "syncthing" "folders" ] [ "services" "syncthing" "settings" "folders" ])
    (mkRenamedOptionModule [ "services" "syncthing" "devices" ] [ "services" "syncthing" "settings" "devices" ])
    (mkRenamedOptionModule [ "services" "syncthing" "options" ] [ "services" "syncthing" "settings" "options" ])
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
      # upstream reference:
      # https://github.com/syncthing/syncthing/blob/main/etc/linux-systemd/system/syncthing%40.service
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
          SuccessExitStatus = "3 4";
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
      syncthing-init = mkIf (cleanedConfig != {}) {
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
