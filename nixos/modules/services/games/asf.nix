{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.archisteamfarm;

  format = pkgs.formats.json { };

  asf-config = format.generate "ASF.json" (cfg.settings // {
    # we disable it because ASF cannot update itself anyways
    # and nixos takes care of restarting the service
    # is in theory not needed as this is already the default for default builds
    UpdateChannel = 0;
    Headless = true;
  } // lib.optionalAttrs (cfg.ipcPasswordFile != null) {
    IPCPassword = "#ipcPassword#";
  });

  ipc-config = format.generate "IPC.config" cfg.ipcSettings;

  mkBot = n: c:
    format.generate "${n}.json" (c.settings // {
      SteamLogin = if c.username == "" then n else c.username;
      SteamPassword = c.passwordFile;
      # sets the password format to file (https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Security#file)
      PasswordFormat = 4;
      Enabled = c.enabled;
    });
in
{
  options.services.archisteamfarm = {
    enable = mkOption {
      type = types.bool;
      description = lib.mdDoc ''
        If enabled, starts the ArchisSteamFarm service.
        For configuring the SteamGuard token you will need to use the web-ui, which is enabled by default over on 127.0.0.1:1242.
        You cannot configure ASF in any way outside of nix, since all the config files get wiped on restart and replaced with the programnatically set ones by nix.
      '';
      default = false;
    };

    web-ui = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption "" // {
            description = lib.mdDoc "Whether to start the web-ui. This is the preferred way of configuring things such as the steam guard token.";
          };

          package = mkOption {
            type = types.package;
            default = pkgs.ArchiSteamFarm.ui;
            defaultText = lib.literalExpression "pkgs.ArchiSteamFarm.ui";
            description =
              lib.mdDoc "Web-UI package to use. Contents must be in lib/dist.";
          };
        };
      };
      default = {
        enable = true;
      };
      example = {
        enable = false;
      };
      description = lib.mdDoc "The Web-UI hosted on 127.0.0.1:1242.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ArchiSteamFarm;
      defaultText = lib.literalExpression "pkgs.ArchiSteamFarm";
      description =
        lib.mdDoc "Package to use. Should always be the latest version, for security reasons, since this module uses very new features and to not get out of sync with the Steam API.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/asf";
      description = lib.mdDoc ''
        The ASF home directory used to store all data.
        If left as the default value this directory will automatically be created before the ASF server starts, otherwise the sysadmin is responsible for ensuring the directory exists with appropriate ownership and permissions.'';
    };

    settings = mkOption {
      type = format.type;
      description = lib.mdDoc ''
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

    ipcPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc "Path to a file containing the password. The file must be readable by the `asf` user/group.";
    };

    ipcSettings = mkOption {
      type = format.type;
      description = lib.mdDoc ''
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

    bots = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          username = mkOption {
            type = types.str;
            description = lib.mdDoc "Name of the user to log in. Default is attribute name.";
            default = "";
          };
          passwordFile = mkOption {
            type = types.path;
            description = lib.mdDoc "Path to a file containing the password. The file must be readable by the `asf` user/group.";
          };
          enabled = mkOption {
            type = types.bool;
            default = true;
            description = lib.mdDoc "Whether to enable the bot on startup.";
          };
          settings = mkOption {
            type = types.attrs;
            description = lib.mdDoc ''
              Additional settings that are documented [here](https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration#bot-config).
            '';
            default = { };
          };
        };
      });
      description = lib.mdDoc ''
        Bots name and configuration.
      '';
      example = {
        exampleBot = {
          username = "alice";
          passwordFile = "/var/lib/asf/secrets/password";
          settings = { SteamParentalCode = "1234"; };
        };
      };
      default = { };
    };
  };

  config = mkIf cfg.enable {

    users = {
      users.asf = {
        home = cfg.dataDir;
        isSystemUser = true;
        group = "asf";
        description = "Archis-Steam-Farm service user";
      };
      groups.asf = { };
    };

    systemd.services = {
      asf = {
        description = "Archis-Steam-Farm Service";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = mkMerge [
          (mkIf (cfg.dataDir == "/var/lib/asf") {
            StateDirectory = "asf";
            StateDirectoryMode = "700";
          })
          {
            User = "asf";
            Group = "asf";
            WorkingDirectory = cfg.dataDir;
            Type = "simple";
            ExecStart = "${cfg.package}/bin/ArchiSteamFarm --path ${cfg.dataDir} --process-required --no-restart --service --no-config-migrate";
            Restart = "always";

            # mostly copied from the default systemd service
            PrivateTmp = true;
            LockPersonality = true;
            PrivateDevices = true;
            PrivateIPC = true;
            PrivateMounts = true;
            PrivateUsers = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "full";
            RemoveIPC = true;
            RestrictAddressFamilies = "AF_INET AF_INET6";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
          }
        ];

        preStart =
          let
            createBotsScript = pkgs.runCommandLocal "ASF-bots" { } ''
              mkdir -p $out
              # clean potential removed bots
              rm -rf $out/*.json
              for i in ${strings.concatStringsSep " " (lists.map (x: "${getName x},${x}") (attrsets.mapAttrsToList mkBot cfg.bots))}; do IFS=",";
                set -- $i
                ln -fs $2 $out/$1
              done
            '';
            replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
          in
          ''
            mkdir -p config

            cp --no-preserve=mode ${asf-config} config/ASF.json

            ${optionalString (cfg.ipcPasswordFile != null) ''
              ${replaceSecretBin} '#ipcPassword#' '${cfg.ipcPasswordFile}' config/ASF.json
            ''}

            ${optionalString (cfg.ipcSettings != {}) ''
              ln -fs ${ipc-config} config/IPC.config
            ''}

            ${optionalString (cfg.ipcSettings != {}) ''
              ln -fs ${createBotsScript}/* config/
            ''}

            rm -f www
            ${optionalString cfg.web-ui.enable ''
              ln -s ${cfg.web-ui.package}/lib/dist www
            ''}
          '';
      };
    };
  };

  meta = {
    buildDocsInSandbox = false;
    maintainers = with maintainers; [ lom SuperSandro2000 ];
  };
}
