{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.crossfire-server;
  serverPort = 13327;
in
{
  options.services.crossfire-server = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If enabled, the Crossfire game server will be started at boot.
      '';
    };

    package = lib.mkPackageOption pkgs "crossfire-server" {
      extraDescription = ''
        ::: {.note}
        This will also be used for map/arch data, if you don't change {option}`dataDir`
        :::
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.package}/share/crossfire";
      defaultText = lib.literalExpression ''"''${config.services.crossfire.package}/share/crossfire"'';
      description = ''
        Where to load readonly data from -- maps, archetypes, treasure tables,
        and the like. If you plan to edit the data on the live server (rather
        than overlaying the crossfire-maps and crossfire-arch packages and
        nixos-rebuilding), point this somewhere read-write and copy the data
        there before starting the server.
      '';
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/crossfire";
      description = ''
        Where to store runtime data (save files, persistent items, etc).

        If left at the default, this will be automatically created on server
        startup if it does not already exist. If changed, it is the admin's
        responsibility to make sure that the directory exists and is writeable
        by the `crossfire` user.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open ports in the firewall for the server.
      '';
    };

    configFiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = ''
        Text to append to the corresponding configuration files. Note that the
        files given in the example are *not* the complete set of files available
        to customize; look in /etc/crossfire after enabling the server to see
        the available files, and read the comments in each file for detailed
        documentation on the format and what settings are available.

        Note that the motd, rules, and news files, if configured here, will
        overwrite the example files that come with the server, rather than being
        appended to them as the other configuration files are.
      '';
      example = lib.literalExpression ''
        {
          dm_file = '''
            admin:secret_password:localhost
            alice:xyzzy:*
          ''';
          ban_file = '''
            # Bob is a jerk
            bob@*
            # So is everyone on 192.168.86.255/24
            *@192.168.86.
          ''';
          metaserver2 = '''
            metaserver2_notification on
            localhostname crossfire.example.net
          ''';
          motd = "Welcome to CrossFire!";
          news = "No news yet.";
          rules = "Don't be a jerk.";
          settings = '''
            # be nicer to newbies and harsher to experienced players
            balanced_stat_loss true
            # don't let players pick up and use admin-created items
            real_wiz false
          ''';
        }
      '';
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.crossfire = {
      description = "Crossfire server daemon user";
      home = cfg.stateDir;
      createHome = false;
      isSystemUser = true;
      group = "crossfire";
    };
    users.groups.crossfire = { };

    # Merge the cfg.configFiles setting with the default files shipped with
    # Crossfire.
    # For most files this consists of reading ${crossfire}/etc/crossfire/${name}
    # and appending the user setting to it; the motd, news, and rules are handled
    # specially, with user-provided values completely replacing the original.
    environment.etc =
      lib.attrsets.mapAttrs'
        (
          name: value:
          lib.attrsets.nameValuePair "crossfire/${name}" {
            mode = "0644";
            text =
              (lib.optionalString (
                !lib.elem name [
                  "motd"
                  "news"
                  "rules"
                ]
              ) (lib.fileContents "${cfg.package}/etc/crossfire/${name}"))
              + "\n${value}";
          }
        )
        (
          {
            ban_file = "";
            dm_file = "";
            exp_table = "";
            forbid = "";
            metaserver2 = "";
            motd = lib.fileContents "${cfg.package}/etc/crossfire/motd";
            news = lib.fileContents "${cfg.package}/etc/crossfire/news";
            rules = lib.fileContents "${cfg.package}/etc/crossfire/rules";
            settings = "";
            stat_bonus = "";
          }
          // cfg.configFiles
        );

    systemd.services.crossfire-server = {
      description = "Crossfire Server Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = lib.mkMerge [
        {
          ExecStart = "${cfg.package}/bin/crossfire-server -conf /etc/crossfire -local '${cfg.stateDir}' -data '${cfg.dataDir}'";
          Restart = "always";
          User = "crossfire";
          Group = "crossfire";
          WorkingDirectory = cfg.stateDir;
        }
        (lib.mkIf (cfg.stateDir == "/var/lib/crossfire") {
          StateDirectory = "crossfire";
        })
      ];

      # The crossfire server needs access to a bunch of files at runtime that
      # are not created automatically at server startup; they're meant to be
      # installed in $PREFIX/var/crossfire by `make install`. And those files
      # need to be writeable, so we can't just point at the ones in the nix
      # store. Instead we take the approach of copying them out of the store
      # on first run. If `bookarch` already exists, we assume the rest of the
      # files do as well, and copy nothing -- otherwise we risk overwriting
      # server state information every time the server is upgraded.
      preStart = ''
        if [ ! -e "${cfg.stateDir}"/bookarch ]; then
          ${pkgs.rsync}/bin/rsync -a --chmod=u=rwX,go=rX \
            "${cfg.package}/var/crossfire/" "${cfg.stateDir}/"
        fi
      '';
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ serverPort ];
    };
  };
}
