{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.factorio;
  name = "Factorio";
  stateDir = "/var/lib/${cfg.stateDirName}";
  mkSavePath = name: "${stateDir}/saves/${name}.zip";
  configFile = pkgs.writeText "factorio.conf" ''
    use-system-read-write-data-directories=true
    [path]
    read-data=${cfg.package}/share/factorio/data
    write-data=${stateDir}
  '';
  serverSettings = {
    name = cfg.game-name;
    description = cfg.description;
    visibility = {
      public = cfg.public;
      lan = cfg.lan;
    };
    username = cfg.username;
    password = cfg.password;
    token = cfg.token;
    game_password = cfg.game-password;
    require_user_verification = cfg.requireUserVerification;
    max_upload_in_kilobytes_per_second = 0;
    minimum_latency_in_ticks = 0;
    ignore_player_limit_for_returning_players = false;
    allow_commands = "admins-only";
    autosave_interval = cfg.autosave-interval;
    autosave_slots = 5;
    afk_autokick_interval = 0;
    auto_pause = true;
    only_admins_can_pause_the_game = true;
    autosave_only_on_server = true;
    non_blocking_saving = cfg.nonBlockingSaving;
  }
  // cfg.extraSettings;
  serverSettingsString = builtins.toJSON (lib.filterAttrsRecursive (n: v: v != null) serverSettings);
  serverSettingsFile = pkgs.writeText "server-settings.json" serverSettingsString;
  playerListOption =
    name: list:
    lib.optionalString (
      list != [ ]
    ) "--${name}=${pkgs.writeText "${name}.json" (builtins.toJSON list)}";
  modDir = pkgs.factorio-utils.mkModDirDrv cfg.mods cfg.mods-dat;
in
{
  options = {
    services.factorio = {
      enable = lib.mkEnableOption name;
      port = lib.mkOption {
        type = lib.types.port;
        default = 34197;
        description = ''
          The port to which the service should bind.
        '';
      };

      bind = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = ''
          The address to which the service should bind.
        '';
      };

      allowedPlayers = lib.mkOption {
        # I would personally prefer for `allowedPlayers = []` to mean "no-one
        # can connect" but Factorio seems to ignore empty whitelists (even with
        # --use-server-whitelist) so we can't implement that behaviour, so we
        # might as well match theirs.
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "Rseding91"
          "Oxyd"
        ];
        description = ''
          If non-empty, only these player names are allowed to connect. The game
          will not be able to save any changes made in-game with the /whitelist
          console command, though they will still take effect until the server
          is restarted.

          If empty, the whitelist defaults to open, but can be managed with the
          in-game /whitelist console command (see: /help whitelist), which will
          cause changes to be saved to the game's state directory (see also:
          `stateDirName`).
        '';
      };
      # Opting not to include the banlist in addition the the whitelist because:
      # - banlists are not as often known in advance,
      # - losing banlist changes on restart seems much more of a headache.

      admins = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "username" ];
        description = ''
          List of player names which will be admin.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to automatically open the specified UDP port in the firewall.
        '';
      };
      saveName = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = ''
          The name of the savegame that will be used by the server.

          When not present in /var/lib/''${config.services.factorio.stateDirName}/saves,
          a new map with default settings will be generated before starting the service.
        '';
      };
      loadLatestSave = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Load the latest savegame on startup. This overrides saveName, in that the latest
          save will always be used even if a saved game of the given name exists. It still
          controls the 'canonical' name of the savegame.

          Set this to true to have the server automatically reload a recent autosave after
          a crash or desync.
        '';
      };
      # TODO Add more individual settings as nixos-options?
      # TODO XXX The server tries to copy a newly created config file over the old one
      #   on shutdown, but fails, because it's in the nix store. When is this needed?
      #   Can an admin set options in-game and expect to have them persisted?
      configFile = lib.mkOption {
        type = lib.types.path;
        default = configFile;
        defaultText = lib.literalExpression "configFile";
        description = ''
          The server's configuration file.

          The default file generated by this module contains lines essential to
          the server's operation. Use its contents as a basis for any
          customizations.
        '';
      };
      extraSettingsFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          File, which is dynamically applied to server-settings.json before
          startup.

          This option should be used for credentials.

          For example a settings file could contain:
          ```json
          {
            "game-password": "hunter1"
          }
          ```
        '';
      };
      stateDirName = lib.mkOption {
        type = lib.types.str;
        default = "factorio";
        description = ''
          Name of the directory under /var/lib holding the server's data.

          The configuration and map will be stored here.
        '';
      };
      mods = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = ''
          Mods the server should install and activate.

          The derivations in this list must "build" the mod by simply copying
          the .zip, named correctly, into the output directory. Eventually,
          there will be a way to pull in the most up-to-date list of
          derivations via nixos-channel. Until then, this is for experts only.
        '';
      };
      mods-dat = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Mods settings can be changed by specifying a dat file, in the [mod
          settings file
          format](https://wiki.factorio.com/Mod_settings_file_format).
        '';
      };
      game-name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "Factorio Game";
        description = ''
          Name of the game as it will appear in the game listing.
        '';
      };
      description = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "";
        description = ''
          Description of the game that will appear in the listing.
        '';
      };
      extraSettings = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        example = {
          max_players = 64;
        };
        description = ''
          Extra game configuration that will go into server-settings.json
        '';
      };
      public = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Game will be published on the official Factorio matching server.
        '';
      };
      lan = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Game will be broadcast on LAN.
        '';
      };
      username = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Your factorio.com login credentials. Required for games with visibility public.

          This option is insecure. Use extraSettingsFile instead.
        '';
      };
      package = lib.mkPackageOption pkgs "factorio-headless" {
        example = "factorio-headless-experimental";
      };
      password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Your factorio.com login credentials. Required for games with visibility public.

          This option is insecure. Use extraSettingsFile instead.
        '';
      };
      token = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Authentication token. May be used instead of 'password' above.
        '';
      };
      game-password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Game password.

          This option is insecure. Use extraSettingsFile instead.
        '';
      };
      requireUserVerification = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          When set to true, the server will only allow clients that have a valid factorio.com account.
        '';
      };
      autosave-interval = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 10;
        description = ''
          Autosave interval in minutes.
        '';
      };
      nonBlockingSaving = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Highly experimental feature, enable only at your own risk of losing your saves.
          On UNIX systems, server will fork itself to create an autosave.
          Autosaving on connected Windows clients will be disabled regardless of autosave_only_on_server option.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.factorio = {
      description = "Factorio headless server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart =
        (toString [
          "test -e ${stateDir}/saves/${cfg.saveName}.zip"
          "||"
          "${cfg.package}/bin/factorio"
          "--config=${cfg.configFile}"
          "--create=${mkSavePath cfg.saveName}"
          (lib.optionalString (cfg.mods != [ ]) "--mod-directory=${modDir}")
        ])
        + (lib.optionalString (cfg.extraSettingsFile != null) (
          "\necho ${lib.strings.escapeShellArg serverSettingsString}"
          + " \"$(cat ${cfg.extraSettingsFile})\" | ${lib.getExe pkgs.jq} -s add"
          + " > ${stateDir}/server-settings.json"
        ));

      serviceConfig = {
        Restart = "always";
        KillSignal = "SIGINT";
        DynamicUser = true;
        StateDirectory = cfg.stateDirName;
        UMask = "0007";
        ExecStart = toString [
          "${cfg.package}/bin/factorio"
          "--config=${cfg.configFile}"
          "--port=${toString cfg.port}"
          "--bind=${cfg.bind}"
          (lib.optionalString (!cfg.loadLatestSave) "--start-server=${mkSavePath cfg.saveName}")
          "--server-settings=${
            if (cfg.extraSettingsFile != null) then "${stateDir}/server-settings.json" else serverSettingsFile
          }"
          (lib.optionalString cfg.loadLatestSave "--start-server-load-latest")
          (lib.optionalString (cfg.mods != [ ]) "--mod-directory=${modDir}")
          (playerListOption "server-adminlist" cfg.admins)
          (playerListOption "server-whitelist" cfg.allowedPlayers)
          (lib.optionalString (cfg.allowedPlayers != [ ]) "--use-server-whitelist")
        ];

        # Sandboxing
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictRealtime = true;
        RestrictNamespaces = true;
        MemoryDenyWriteExecute = true;
      };
    };

    networking.firewall.allowedUDPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}
