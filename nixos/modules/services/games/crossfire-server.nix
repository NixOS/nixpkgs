{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.crossfire-server;
  serverPort = 13327;
in {
  options.services.crossfire-server = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, the Crossfire game server will be started at boot.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.crossfire-server-stable;
      defaultText = "pkgs.crossfire-server-stable";
      example = literalExample "pkgs.crossfire-server-latest";
      description = ''
        The package to use for the Crossfire server (and map/arch data, if you
        don't change dataDir).
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "${cfg.package}/share/crossfire";
      defaultText = "\${services.crossfire.package}/share/crossfire";
      description = ''
        Where to load readonly data from -- maps, archetypes, treasure tables,
        and the like. If you plan to edit the data on the live server (rather
        than overlaying the crossfire-maps and crossfire-arch packages and
        nixos-rebuilding), point this somewhere read-write and copy the data
        there before starting the server.
      '';
    };

    runtimeDir = mkOption {
      type = types.str;
      default = "/srv/crossfire";
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

    etc = mkOption {
      type = types.attrsOf types.str;
      description = ''
        Text to append to the corresponding configuration files. For the format
        of each of these, consult the documentation in the corresponding file
        in ${cfg.package}/etc/.
      '';
      default = {};
    };
  };

  config = mkIf cfg.enable {
    users.users.crossfire = {
      description     = "Crossfire server daemon user";
      home            = cfg.runtimeDir;
      createHome      = true;
    };

    environment.etc = lib.attrsets.mapAttrs'
      (name: value: lib.attrsets.nameValuePair "crossfire/${name}" {
        mode = "0644";
        text =
          (optionalString (!elem name ["motd" "news" "rules"])
            (fileContents "${cfg.package}/etc/crossfire/${name}"))
          + "\n${value}";
      }) ({
        ban_file = "";
        dm_file = "";
        exp_table = "";
        forbid = "";
        metaserver2 = "";
        motd = (fileContents "${cfg.package}/etc/crossfire/motd");
        news = (fileContents "${cfg.package}/etc/crossfire/news");
        rules = (fileContents "${cfg.package}/etc/crossfire/rules");
        settings = "";
        stat_bonus = "";
      } // cfg.etc);

    systemd.services.crossfire-server = {
      description   = "Crossfire Server Daemon";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/crossfire-server -conf /etc/crossfire -local '${cfg.runtimeDir}' -data '${cfg.dataDir}'";
        Restart = "always";
        User = "crossfire";
        WorkingDirectory = cfg.runtimeDir;
      };

      preStart = ''
        if [ ! -e ${cfg.runtimeDir}/bookarch ]; then
          ${pkgs.rsync}/bin/rsync -a --chmod=u=rwX,go=rX \
            "${cfg.package}/var/crossfire/" "${cfg.runtimeDir}/"
        fi
      '';
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ serverPort ];
    };
  };
}
