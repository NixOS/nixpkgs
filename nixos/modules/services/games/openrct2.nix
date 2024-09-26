{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.openrct2;

  parkOptions =
    { name, ... }:
    {
      options = {
        listenAddress = mkOption {
          type = types.str;
          default = "";
          description = "Address to listen on.";
          example = "0.0.0.0";
        };

        port = mkOption {
          type = types.port;
          default = 11753;
          description = "Port to listen on.";
        };

        advertise = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Wether to advertise our server to the master server, making it
            visible in the public listing.
          '';
        };

        advertiseAddress = mkOption {
          type = types.str;
          default = "";
          description = "Address to advertise to the master server.";
          example = "128.66.43.85";
        };

        password = mkOption {
          type = types.str;
          default = null;
          description = "Password needed to join the server.";
        };

        autosave = mkOption {
          type = types.int;
          default = 0;
          description = mdDoc ''
            Autosave frequency.

            We rely on the autosave mechanism to keep the game state through
            restarts or other misfortunes, so it's recommended to set this to `0`
            or `1` to enable autosaves every 1 or 5 minute(s) respectively.

            Autosaves are saved to the `${cfg.dataDirRoot}/${name}/save/autosave` directory.

            | value | frequency         |
            | ----- | ----------------- |
            |   0   | (every) 1 minute  |
            |   1   | 5 minutes         |
            |   2   | 10 minutes        |
            |   3   | 15 minutes        |
            |   4   | 20 minutes        |
            |   5   | disable           |
          '';
        };

        autosaveAmount = mkOption {
          type = types.int;
          default = 60;
          description = "Amount of autosaves to keep.";
        };

        autoRestoreAutosave = mkOption {
          type = types.bool;
          default = true;
          description = mdDoc ''
            Whether to automatically restore the latest autosave on startup.

            If set to `true`, the latest autosave will automatically be restored
            on startup. Use this in combination with a high frequency `autosave`
            value (like `0` to autosave every 1 minute), to limit lost in-game
            time on server restarts.
          '';
        };

        playerName = mkOption {
          type = types.str;
          default = "${name} Server";
          description = "Name of the player for the server that hosts the game.";
        };

        maxPlayers = mkOption {
          type = types.int;
          default = 16;
          description = "Maximum amount of online players to allow.";
        };

        dataDir = mkOption {
          type = types.path;
          default = "${cfg.dataDirRoot}/${name}";
          description = ''
            Path to the park data directory.

            Most importantly, this directory contains the savegames under
            `save/autosave` and the current park file at `${name}.park`.
          '';
        };

        settings = mkOption {
          type = format.type;
          default = { };
          description = "OpenRCT2 config.ini";
          example = literalExpression ''
            {
                      general = {
                        currency_format = "EUR";
                        date_format = "DD/MM/YY";
                      };
                      network = {
                        pause_server_if_no_clients = true;
                      };
                      plugin = {
                        enable_hot_reloading = true;
                      };
                    }'';
        };
      };
    };

  mkService = name: park: {
    description = "OpenRCT2 Server - ${name}";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = ''${cfg.package}/bin/openrct2-cli host "${park.dataDir}/${name}.park" --headless "--user-data-path=${park.dataDir}" ${
        if cfg.gamePath == "" then "" else ''"--rct2-data-path=${cfg.gamePath}"''
      } ${
        if cfg.rct1Path == "" then "" else ''"--rct1-data-path=${cfg.rct1Path}"''
      } --port ${toString park.port}'';
      Restart = "always";
      User = cfg.user;
      WorkingDirectory = park.dataDir;

      ProtectHome = true;
      RestrictNamespaces = true;
      PrivateTmp = true;
      PrivateUsers = true;
      PrivateDevices = true;
    };

    preStart = ''
      mkdir -p "${park.dataDir}"

      # Update the config symlink
      if test -f "${park.dataDir}/config.ini"; then
        # The current config file is not a symlink so not managed by us,
        # let's make a backup just in case.
        cp -f "${park.dataDir}/config.ini" "${park.dataDir}/config.ini.auto_backup"
      fi
      rm -f "${park.dataDir}/config.ini"
      ln -sf "${parkConfigFiles.${name}}" "${park.dataDir}/config.ini"


      # Make sure we start using the latest saved park
      mkdir -p "${park.dataDir}/save/autosave"

      autoRestoreAutosave=${if park.autoRestoreAutosave then "true" else "false"}
      latest_autosave=$(
        find "${park.dataDir}/save/autosave" -type f -exec ls -lt --time-style=+%s {} \; \
          |sort -k 6 -n |tail -n 1 |${pkgs.gawk}/bin/awk '{print $7}')

      if $autoRestoreAutosave && test -n "$latest_autosave"; then
        if test -f "${park.dataDir}/${name}.park"; then
          mkdir -p "$(dirname "$backup_file")"
          backup_file="${park.dataDir}/backup/autobackup_$(date '+%Y-%m-%d_%H:%M:%S')_${name}.park"

          echo "Backing up existing park to $backup_file"
          mv "${park.dataDir}/${name}.park" "$backup_file"
        fi

        echo "Restoring park from latest autosave $(basename $latest_autosave)"
        cp "$latest_autosave" "${park.dataDir}/${name}.park"
      fi
    '';
  };

  mkParkConfig =
    name: park:
    recursiveUpdate {
      general = {
        autosave = park.autosave;
        autosave_amount = park.autosaveAmount;
        rct1_path = "${if isNull cfg.rct1Path then "" else cfg.rct1Path}";
        game_path = cfg.gamePath;
      };

      network = {
        player_name = park.playerName;
        default_port = park.port;
        listen_address = park.listenAddress;
        advertise = park.advertise;
        advertise_address = park.advertiseAddress;
        maxplayers = park.maxPlayers;
      };
    } park.settings;

  format = pkgs.formats.ini { };

  parkConfigs = mapAttrs (name: value: mkParkConfig name value) cfg.parks;

  parkConfigFiles = mapAttrs (name: value: format.generate "${name}-config.ini" value) parkConfigs;

in
{
  options.services.openrct2 = {
    enable = mkEnableOption (lib.mdDoc ''OpenRCT2 headless game server.'');

    user = mkOption {
      type = types.str;
      default = "openrct2";
      description = mdDoc ''The user under which openrct2 runs.'';
    };

    group = mkOption {
      type = types.str;
      default = "openrct2";
      description = mdDoc ''The group under which openrct2 runs.'';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.openrct2;
      defaultText = literalExpression "pkgs.openrct2";
      description = mdDoc ''OpenRCT2 package to use.'';
    };

    dataDirRoot = mkOption {
      type = types.path;
      default = "/srv/openrct2";
      description = mdDoc ''Directory to store stuff.'';
    };

    rct1Path = mkOption {
      type = types.str;
      description = "Path to an original Roller Coaster Tycoon 1 installation.";
      example = "${cfg.dataDirRoot}/RollerCoaster Tycoon Deluxe";
      default = "";
    };

    gamePath = mkOption {
      type = types.str;
      description = "Path to an original Roller Coaster Tycoon 2 installation.";
      example = "${cfg.dataDirRoot}/RollerCoaster Tycoon 2 Triple Thrill Pack";
      default = "";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Allow incoming connections on the listening port.";
    };

    parks = mkOption {
      description = mdDoc ''Parks to host.'';
      type = types.attrsOf (types.submodule parkOptions);
    };
  };

  config = mkIf config.services.openrct2.enable {
    users.users.openrct2 = mkIf (cfg.user == "openrct2") {
      description = "OpenRCT2";
      home = cfg.dataDirRoot;
      createHome = true;
      isSystemUser = true;
      uid = config.ids.uids.openrct2;
      group = cfg.group;
    };

    users.groups.openrct2 = mkIf (cfg.group == "openrct2") { gid = config.ids.gids.openrct2; };

    systemd.services = mapAttrs' (
      name: value: nameValuePair "openrct2-${name}" (mkService name value)
    ) cfg.parks;

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = mapAttrsToList (name: value: value.port) cfg.parks;
    };
  };
}
