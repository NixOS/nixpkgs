{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.vrising-server;
  varLibStateDir = "/var/lib/${cfg.stateDir}";
  format = pkgs.formats.json { };
in {
  options = {
    services.vrising-server = {
      enable = mkEnableOption "V Rising dedicated server";

      stateDir = mkOption {
        type = types.str;
        default = "vrising-server";
        description = ''
          Directory to store all stateful configuration, logs and save files.
          Will be created as subdirectory of <literal>/var/lib/</literal>.
        '';
      };

      passwordFile = mkOption {
        type = types.path;
        description = ''
          File that contains the password for the server.
        '';
      };

      openFirewall = mkEnableOption ''
        Whether to open the ports for the server defined in hostSettings in the firewall.
      '';

      hostSettings = mkOption {
        type = types.submodule {
          freeformType = format.type;

          options = {
            port = mkOption {
              type = types.port;
              default = 9876;
              description = ''
                Port for the server, will be added to allowedUDPPorts.
              '';
            };

            queryPort = mkOption {
              type = types.port;
              default = 9877;
              description = ''
                Query port for the server, will be added to allowedUDPPorts.
              '';
            };
          };
        };
        default = { };
        example = literalExpression ''
          {
            Name = "V Rising Server";
            Description = "";
            MaxConnectedUsers = 5;
            MaxConnectedAdmins = 5;
            ServerFps = 30;
            SaveName = "world1";
            Secure = true;
            ListOnMasterServer = false;
            AutoSaveCount = 20;
            AutoSaveInterval = 300;
            GameSettingsPreset = "StandardPvE";
            AdminOnlyDebugEvents = true;
            DisableDebugEvents = false;
          }'';
        description = ''
          Host settings as defined in <link xlink:href="https://github.com/StunlockStudios/vrising-dedicated-server-instructions">this repository</link>.
          Look at the reference to see what you can configure in this attribute set.

          Do not set <literal>Password</literal> here but use the dedicated <literal>passwordFile</literal> option instead.
        '';
      };

      gameSettings = mkOption {
        type = format.type;
        default = { };
        example = literalExpression ''
          {
            GameModeType = "PvE";
            DeathContainerPermission = "ClanMembers";
            RelicSpawnType = "Plentiful";
            CastleHeartDamageMode = "CanBeDestroyedOnlyWhenDecaying";
            CastleDamageMode = "Never";
            BloodBoundEquipment = true;
            CanLootEnemyContainers = false;
            Death_DurabilityFactorLoss = 0.0;
            Death_DurabilityLossFactorAsResources = 0.0;
            AnnounceSiegeWeaponSpawn = false;
          }'';
        description = ''
          Game settings as defined in <link xlink:href="https://cdn.stunlock.com/blog/2022/05/25083113/Game-Server-Settings.pdf">this file</link>.
          Look at the reference to see what you can configure in this attribute set.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    warnings = optional (cfg.hostSettings ? Password) ''
      You have defined a host password using the hostSettings option, which
      will be ignored. Use the dedicated passwordFile option instead.
    '';

    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [
      cfg.hostSettings.port
      cfg.hostSettings.queryPort
    ];

    systemd.services.vrising-server = {
      description = "V Rising dedicated server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      environment = {
        # steamcmd uses $HOME/.local for temporary files
        HOME = varLibStateDir;
        saveDir = "./save-data";
      };

      serviceConfig = {
        ExecStartPre = ''
          ${pkgs.steamcmd}/bin/steamcmd \
            +force_install_dir ${varLibStateDir} \
            +login anonymous \
            +app_update 1829350 \
            +quit
        '';
        # sometimes winedevice processes are left running https://github.com/lutris/lutris/issues/4046
        ExecStop = "${pkgs.wine64}/bin/wineserver -k";
        WorkingDirectory = varLibStateDir;
        Restart = "no";
        StateDirectory = cfg.stateDir;
        DynamicUser = true;
        # in case execstop does not kill all winedevice processes
        TimeoutStopSec = 10;
        LoadCredential = "password:${cfg.passwordFile}";

        # Hardening
        SystemCallFilter = "@system-service @mount @debug";
        SystemCallErrorNumber = "EPERM";
        CapabilityBoundingSet = "";
        RestrictNamespaces = "cgroup mnt user uts";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
      };

      # script is needed here since loadcredential is not accessible in
      # ExecPreStart. Wine sometimes fails with dll import errors, removing
      # .wine resolves this, same issue as reported in the first comment of this
      # PR https://github.com/NixOS/nixpkgs/pull/157921
      script = ''
        rm -rf .wine
        mkdir -p $saveDir/Settings
        ${pkgs.jq}/bin/jq --slurpfile pw <(${pkgs.jq}/bin/jq -R . < $CREDENTIALS_DIRECTORY/password ) \
          '.Password = $pw[0]' ${
            format.generate "hostSettings.json" cfg.hostSettings
          } > $saveDir/Settings/ServerHostSettings.json
        ln -sf ${
          format.generate "gameSettings.json" cfg.gameSettings
        } $saveDir/Settings/ServerGameSettings.json
        exec ${pkgs.xvfb-run}/bin/xvfb-run \
          --auto-servernum \
          --server-args='-screen 0 320x180x8' \
          ${pkgs.wine64}/bin/wine64 VRisingServer.exe \
          -persistentDataPath $saveDir \
          -logFile server.log
      '';
    };
  };
}
