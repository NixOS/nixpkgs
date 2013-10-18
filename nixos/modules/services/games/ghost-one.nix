{pkgs, config, ...}:
with pkgs.lib;
let

  cfg = config.services.ghostOne;
  ghostUser = "ghostone";
  stateDir = "/var/lib/ghost-one";

in
{

  ###### interface

  options = {
    services.ghostOne = {

      enable = mkOption {
        default = false;
        description = "Enable Ghost-One Warcraft3 game hosting server.";
      };

      language = mkOption {
        default = "English";
        check = lang: elem lang [ "English" "Spanish" "Russian" "Serbian" "Turkish" ];
        description = "The language of bot messages: English, Spanish, Russian, Serbian or Turkish.";
      };

      war3path = mkOption {
        default = "";
        description = ''
          The path to your local Warcraft III directory, which must contain war3.exe, storm.dll, and game.dll.
        '';
      };

      mappath = mkOption {
        default = "";
        description = ''
          The path to the directory where you keep your map files. GHost One doesn't require
          map files but if it has access to them it can send them to players and automatically
          calculate most map config values. GHost One will search [bot_mappath + map_localpath]
          for the map file (map_localpath is set in each map's config file).
        '';
      };

      config = mkOption {
        default = "";
        description = "Extra configuration options.";
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = ghostUser;
        uid = config.ids.uids.ghostOne;
        description = "Ghost One game server user";
        home = stateDir;
      };

    users.extraGroups = singleton
      { name = ghostUser;
        gid = config.ids.gids.ghostOne;
      };

    services.ghostOne.config = ''
#      bot_log = /dev/stderr
      bot_language = ${pkgs.ghostOne}/share/ghost-one/languages/${cfg.language}.cfg
      bot_war3path = ${cfg.war3path}

      bot_mapcfgpath = mapcfgs
      bot_savegamepath = savegames
      bot_mappath = ${cfg.mappath}
      bot_replaypath = replays
    '';

    jobs.ghostOne = {
      name = "ghost-one";
      script = ''
        mkdir -p ${stateDir}
        cd ${stateDir}
        chown ${ghostUser}:${ghostUser} .

        mkdir -p mapcfgs
        chown ${ghostUser}:${ghostUser} mapcfgs

        mkdir -p replays
        chown ${ghostUser}:${ghostUser} replays

        mkdir -p savegames
        chown ${ghostUser}:${ghostUser} savegames

        ln -sf ${pkgs.writeText "ghost.cfg" cfg.config} ghost.cfg
        ln -sf ${pkgs.ghostOne}/share/ghost-one/ip-to-country.csv
        ${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${ghostUser} \
          -c "LANG=C ${pkgs.ghostOne}/bin/ghost++"
      '';
    };

  };

}
