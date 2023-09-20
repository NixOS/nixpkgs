{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.deliantra-server;
  serverPort = 13327;
in {
  options.services.deliantra-server = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        If enabled, the Deliantra game server will be started at boot.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.deliantra-server;
      defaultText = literalExpression "pkgs.deliantra-server";
      description = lib.mdDoc ''
        The package to use for the Deliantra server (and map/arch data, if you
        don't change dataDir).
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "${pkgs.deliantra-data}";
      defaultText = literalExpression ''"''${pkgs.deliantra-data}"'';
      description = lib.mdDoc ''
        Where to store readonly data (maps, archetypes, sprites, etc).
        Note that if you plan to use the live map editor (rather than editing
        the maps offline and then nixos-rebuilding), THIS MUST BE WRITEABLE --
        copy the deliantra-data someplace writeable (say,
        /var/lib/deliantra/data) and update this option accordingly.
      '';
    };

    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/deliantra";
      description = lib.mdDoc ''
        Where to store runtime data (save files, persistent items, etc).

        If left at the default, this will be automatically created on server
        startup if it does not already exist. If changed, it is the admin's
        responsibility to make sure that the directory exists and is writeable
        by the `crossfire` user.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to open ports in the firewall for the server.
      '';
    };

    configFiles = mkOption {
      type = types.attrsOf types.str;
      description = lib.mdDoc ''
        Contents of the server configuration files. These will be appended to
        the example configurations the server comes with and overwrite any
        default settings defined therein.

        The example here is not comprehensive. See the files in
        /etc/deliantra-server after enabling this module for full documentation.
      '';
      example = literalExpression ''
        {
          dm_file = '''
            admin:secret_password:localhost
            alice:xyzzy:*
          ''';
          motd = "Welcome to Deliantra!";
          settings = '''
            # Settings for game mechanics.
            stat_loss_on_death true
            armor_max_enchant 7
          ''';
          config = '''
            # Settings for the server daemon.
            hiscore_url https://deliantra.example.net/scores/
            max_map_reset 86400
          ''';
        }
      '';
      default = {
        motd = "";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.deliantra = {
      description     = "Deliantra server daemon user";
      home            = cfg.stateDir;
      createHome      = false;
      isSystemUser    = true;
      group           = "deliantra";
    };
    users.groups.deliantra = {};

    # Merge the cfg.configFiles setting with the default files shipped with
    # Deliantra.
    # For most files this consists of reading
    # ${deliantra}/etc/deliantra-server/${name} and appending the user setting
    # to it.
    environment.etc = lib.attrsets.mapAttrs'
      (name: value: lib.attrsets.nameValuePair "deliantra-server/${name}" {
        mode = "0644";
        text =
          # Deliantra doesn't come with a motd file, but respects it if present
          # in /etc.
          (optionalString (name != "motd")
            (fileContents "${cfg.package}/etc/deliantra-server/${name}"))
          + "\n${value}";
      }) ({
        motd = "";
        settings = "";
        config = "";
        dm_file = "";
      } // cfg.configFiles);

    systemd.services.deliantra-server = {
      description   = "Deliantra Server Daemon";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      environment = {
        DELIANTRA_DATADIR="${cfg.dataDir}";
        DELIANTRA_LOCALDIR="${cfg.stateDir}";
        DELIANTRA_CONFDIR="/etc/deliantra-server";
      };

      serviceConfig = mkMerge [
        {
          ExecStart = "${cfg.package}/bin/deliantra-server";
          Restart = "always";
          User = "deliantra";
          Group = "deliantra";
          WorkingDirectory = cfg.stateDir;
        }
        (mkIf (cfg.stateDir == "/var/lib/deliantra") {
          StateDirectory = "deliantra";
        })
      ];

      # The deliantra server needs access to a bunch of files at runtime that
      # are not created automatically at server startup; they're meant to be
      # installed in $PREFIX/var/deliantra-server by `make install`. And those
      # files need to be writeable, so we can't just point at the ones in the
      # nix store. Instead we take the approach of copying them out of the store
      # on first run. If `bookarch` already exists, we assume the rest of the
      # files do as well, and copy nothing -- otherwise we risk ovewriting
      # server state information every time the server is upgraded.
      preStart = ''
        if [ ! -e "${cfg.stateDir}"/bookarch ]; then
          ${pkgs.rsync}/bin/rsync -a --chmod=u=rwX,go=rX \
            "${cfg.package}/var/deliantra-server/" "${cfg.stateDir}/"
        fi
      '';
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ serverPort ];
    };
  };
}
