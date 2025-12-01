{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.archisteamfarm;

  format = pkgs.formats.json { };

  configFile = format.generate "ASF.json" (
    cfg.settings
    // {
      # we disable it because ASF cannot update itself anyways
      # and nixos takes care of restarting the service
      # is in theory not needed as this is already the default for default builds
      UpdateChannel = 0;
      Headless = true;
    }
    // lib.optionalAttrs (cfg.ipcPasswordFile != null) {
      IPCPassword = "#ipcPassword#";
    }
  );

  ipc-config = format.generate "IPC.config" cfg.ipcSettings;

  mkBot =
    n: c:
    format.generate "${n}.json" (
      c.settings
      // {
        SteamLogin = if c.username == "" then n else c.username;
        Enabled = c.enabled;
      }
      // lib.optionalAttrs (c.passwordFile != null) {
        SteamPassword = c.passwordFile;
        # sets the password format to file (https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Security#file)
        PasswordFormat = 4;
      }
    );
in
{
  options.services.archisteamfarm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = ''
        If enabled, starts the ArchisSteamFarm service.
        For configuring the SteamGuard token you will need to use the web-ui, which is enabled by default over on 127.0.0.1:1242.
        You cannot configure ASF in any way outside of nix, since all the config files get wiped on restart and replaced with the programnatically set ones by nix.
      '';
      default = false;
    };

    web-ui = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "" // {
            description = "Whether to start the web-ui. This is the preferred way of configuring things such as the steam guard token.";
          };

          package = lib.mkPackageOption pkgs [ "ArchiSteamFarm" "ui" ] {
            extraDescription = ''
              ::: {.note}
              Contents must be in lib/dist
              :::
            '';
          };
        };
      };
      default = {
        enable = true;
      };
      example = {
        enable = false;
      };
      description = "The Web-UI hosted on 127.0.0.1:1242.";
    };

    package = lib.mkPackageOption pkgs "ArchiSteamFarm" {
      extraDescription = ''
        ::: {.warning}
        Should always be the latest version, for security reasons,
        since this module uses very new features and to not get out of sync with the Steam API.
        :::
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/archisteamfarm";
      description = ''
        The ASF home directory used to store all data.
        If left as the default value this directory will automatically be created before the ASF server starts, otherwise the sysadmin is responsible for ensuring the directory exists with appropriate ownership and permissions.'';
    };

    settings = lib.mkOption {
      type = format.type;
      description = ''
        The ASF.json file, all the options are documented [here](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration#global-config).
        Do note that `AutoRestart`  and `UpdateChannel` is always to `false` respectively `0` because NixOS takes care of updating everything.
        `Headless` is also always set to `true` because there is no way to provide inputs via a systemd service.
        You should try to keep ASF up to date since upstream does not provide support for anything but the latest version and you're exposing yourself to all kinds of issues - as is outlined [here](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration#updateperiod).
      '';
      example = {
        Statistics = false;
      };
      default = { };
    };

    ipcPasswordFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "Path to a file containing the password. The file must be readable by the `archisteamfarm` user/group.";
    };

    ipcSettings = lib.mkOption {
      type = format.type;
      description = ''
        Settings to write to IPC.config.
        All options can be found [here](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/IPC#custom-configuration).
      '';
      example = {
        Kestrel = {
          Endpoints = {
            HTTP = {
              Url = "http://*:1242";
            };
          };
        };
      };
      default = { };
    };

    bots = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            username = lib.mkOption {
              type = lib.types.str;
              description = "Name of the user to log in. Default is attribute name.";
              default = "";
            };
            passwordFile = lib.mkOption {
              type = with lib.types; nullOr path;
              default = null;
              description = ''
                Path to a file containing the password. The file must be readable by the `archisteamfarm` user/group.
                Omit or set to null to provide the password a different way, such as through the web-ui.
              '';
            };
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to enable the bot on startup.";
            };
            settings = lib.mkOption {
              type = lib.types.attrs;
              description = ''
                Additional settings that are documented [here](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration#bot-config).
              '';
              default = { };
            };
          };
        }
      );
      description = ''
        Bots name and configuration.
      '';
      example = {
        exampleBot = {
          username = "alice";
          passwordFile = "/var/lib/archisteamfarm/secrets/password";
          settings = {
            SteamParentalCode = "1234";
          };
        };
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users.archisteamfarm = {
        home = cfg.dataDir;
        isSystemUser = true;
        group = "archisteamfarm";
        description = "Archis-Steam-Farm service user";
      };
      groups.archisteamfarm = { };
    };

    systemd.services = {
      archisteamfarm = {
        description = "Archis-Steam-Farm Service";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = lib.mkMerge [
          (lib.mkIf (lib.hasPrefix "/var/lib/" cfg.dataDir) {
            StateDirectory = lib.last (lib.splitString "/" cfg.dataDir);
            StateDirectoryMode = "700";
          })
          {
            User = "archisteamfarm";
            Group = "archisteamfarm";
            WorkingDirectory = cfg.dataDir;
            Type = "simple";
            ExecStart = "${lib.getExe cfg.package} --no-restart --service --system-required --path ${cfg.dataDir}";
            Restart = "always";

            # copied from the default systemd service at
            # https://github.com/JustArchiNET/ArchiSteamFarm/blob/main/ArchiSteamFarm/overlay/variant-base/linux/ArchiSteamFarm%40.service
            CapabilityBoundingSet = "";
            DevicePolicy = "closed";
            LockPersonality = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateIPC = true;
            PrivateMounts = true;
            PrivateTmp = true; # instead of rw /tmp
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
            RestrictAddressFamilies = "AF_INET AF_INET6 AF_NETLINK AF_UNIX";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SecureBits = "noroot-locked";
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
              "mincore"
            ];
            UMask = "0077";
          }
        ];

        preStart =
          let
            createBotsScript = pkgs.runCommand "ASF-bots" { } ''
              mkdir -p $out
              # clean potential removed bots
              rm -rf $out/*.json
              for i in ${
                lib.concatStringsSep " " (map (x: "${lib.getName x},${x}") (lib.mapAttrsToList mkBot cfg.bots))
              }; do IFS=",";
                set -- $i
                ln -fs $2 $out/$1
              done
            '';
            replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
          in
          ''
            mkdir -p config

            cp --no-preserve=mode ${configFile} config/ASF.json

            ${lib.optionalString (cfg.ipcPasswordFile != null) ''
              ${replaceSecretBin} '#ipcPassword#' '${cfg.ipcPasswordFile}' config/ASF.json
            ''}

            ${lib.optionalString (cfg.ipcSettings != { }) ''
              ln -fs ${ipc-config} config/IPC.config
            ''}

            ${lib.optionalString (cfg.bots != { }) ''
              ln -fs ${createBotsScript}/* config/
            ''}

            rm -f www
            ${lib.optionalString cfg.web-ui.enable ''
              ln -s ${cfg.web-ui.package}/ www
            ''}
          '';
      };
    };
  };

  meta = {
    buildDocsInSandbox = false;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
