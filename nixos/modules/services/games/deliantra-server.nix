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
      description = ''
        If enabled, the Deliantra game server will be started at boot.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "${pkgs.deliantra-data}";
      defaultText = "\${pkgs.deliantra-data}";
      description = ''
        Where to store readonly data (maps, archetypes, sprites, etc).
        Note that if you plan to use the live map editor (rather than editing
        the maps offline and then nixos-rebuilding), THIS MUST BE WRITEABLE --
        copy the deliantra-data someplace writeable (say, /srv/deliantra/data)
        and update this option accordingly.
      '';
    };

    runtimeDir = mkOption {
      type = types.str;
      default = "/srv/deliantra";
      description = ''
        Where to store runtime data (save files, persistent items, etc).
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open ports in the firewall for the server.
      '';
    };

    settings = mkOption {
      type = types.str;
      default = "";
      example = ''
        stat_loss_on_death true
        armor_max_enchant 7
      '';
      description = ''
        Text to append to the server settings file, which contains settings
        for game mechanics.
      '';
    };

    config = mkOption {
      type = types.str;
      default = "";
      example = ''
        hiscore_url https://deliantra.example.net/scores/
        max_map_reset 86400
      '';
      description = ''
        Text to append to the server config file, which contains settings
        for the server program.
      '';
    };

    dm_file = mkOption {
      type = types.str;
      default = "";
      example = ''
        root:password:localhost
        admin:password:*
        *:masterkey:*
      '';
      description = ''
        List of dungeon masters, in name:password:host format.
      '';
    };

    motd = mkOption {
      type = types.str;
      default = "Welcome to the ${config.networking.hostName} Deliantra server!";
      description = ''
        Message-of-the-day displayed to users on login.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.deliantra = {
      description     = "Deliantra server daemon user";
      home            = cfg.runtimeDir;
      createHome      = true;
    };

    environment.etc = {
      "deliantra-server/settings" = {
        mode = "0644";
        text = (fileContents "${pkgs.deliantra-server}/etc/deliantra-server/settings")
             + "\n${cfg.settings}";
      };
      "deliantra-server/config" = {
        mode = "0644";
        text = (fileContents "${pkgs.deliantra-server}/etc/deliantra-server/config")
             + "\n${cfg.config}";
      };
      "deliantra-server/dm_file" = {
        mode = "0644";
        text = (fileContents "${pkgs.deliantra-server}/etc/deliantra-server/dm_file")
             + "\n${cfg.dm_file}";
      };
      "deliantra-server/motd" = {
        mode = "0644";
        text = "${cfg.dm_file}";
      };
    };

    systemd.services.deliantra-server = {
      description   = "Deliantra Server Daemon";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      environment = {
        DELIANTRA_DATADIR="${pkgs.deliantra-data}";
        DELIANTRA_LOCALDIR="${cfg.runtimeDir}";
        DELIANTRA_CONFDIR="/etc/deliantra-server";
      };

      serviceConfig = {
        ExecStart = "${pkgs.deliantra-server}/bin/deliantra-server";
        Restart = "always";
        User = "deliantra";
        WorkingDirectory = cfg.runtimeDir;
      };

      preStart = ''
        if [ ! -e ${cfg.runtimeDir}/bookarch ]; then
          ${pkgs.rsync}/bin/rsync -a --chmod=u=rwX,go=rX \
            "${pkgs.deliantra-server}/var/deliantra-server/" "${cfg.runtimeDir}/"
        fi
      '';
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ serverPort ];
    };
  };
}
