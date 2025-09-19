{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.services.terraria;
  opt = options.services.terraria;

  worldSizeMap = {
    small = 1;
    medium = 2;
    large = 3;
  };

  difficultyMap = {
    normal = 0;
    expert = 1;
    master = 2;
    journey = 3;
  };

  mkLine = name: val: (lib.optionalString (val != null) "${name}=${toString val}");
  mkTodo = name: "# ${name}= # TODO: add option";

  # Based on https://terraria.wiki.gg/wiki/Server#Server_config_file
  configLines =
    lib.optionals cfg.autocreate.enable [
      (mkLine "autocreate" (builtins.getAttr cfg.autocreate.size worldSizeMap))
      (mkLine "difficulty" (builtins.getAttr cfg.autocreate.difficulty difficultyMap))
      (mkLine "seed" cfg.autocreate.seed)
    ]
    ++ [
      (mkLine "world" cfg.worldPath)
      (mkTodo "worldname")
      (mkLine "maxplayers" cfg.maxPlayers)
      (mkLine "port" cfg.port)
      (mkLine "password" cfg.password)
      (mkLine "motd" cfg.messageOfTheDay)
      (mkTodo "worldpath")
      (mkLine "banlist" cfg.banListPath)
      (mkLine "secure" (if cfg.secure then "1" else "0"))
      (mkLine "upnp" (if cfg.noUPnP then "0" else "1")) # should probably be inverted in the option name instead
      (mkTodo "npcstream")
      (mkTodo "priority")
      (mkTodo "journeypermission_time_setfrozen")
      (mkTodo "journeypermission_time_setdawn")
      (mkTodo "journeypermission_time_setnoon")
      (mkTodo "journeypermission_time_setdusk")
      (mkTodo "journeypermission_time_setmidnight")
      (mkTodo "journeypermission_godmode")
      (mkTodo "journeypermission_wind_setstrength")
      (mkTodo "journeypermission_rain_setstrength")
      (mkTodo "journeypermission_time_setspeed")
      (mkTodo "journeypermission_rain_setfrozen")
      (mkTodo "journeypermission_wind_setfrozen")
      (mkTodo "journeypermission_increaseplacementrange")
      (mkTodo "journeypermission_setdifficulty")
      (mkTodo "journeypermission_biomespread_setfrozen")
      (mkTodo "journeypermission_setspawnrate")
    ];

  configFile = pkgs.writeText "serverconfig.txt" ''
    # This file was created by the services.terraria NixOS module
    ${lib.concatStringsSep "\n" configLines}
  '';

  tmuxCmd = "${lib.getExe pkgs.tmux} -S ${lib.escapeShellArg cfg.dataDir}/terraria.sock";

  stopScript = pkgs.writeShellScript "terraria-stop" ''
    if ! [ -d "/proc/$1" ]; then
      exit 0
    fi

    lastline=$(${tmuxCmd} capture-pane -p | grep . | tail -n1)

    # If the service is not configured to auto-start a world, it will show the world selection prompt
    # If the last non-empty line on-screen starts with "Choose World", we know the prompt is open
    if [[ "$lastline" =~ ^'Choose World' ]]; then
      # In this case, nothing needs to be saved, so we can kill the process
      ${tmuxCmd} kill-session
    else
      # Otherwise, we send the `exit` command
      ${tmuxCmd} send-keys Enter exit Enter
    fi

    # Wait for the process to stop
    tail --pid="$1" -f /dev/null
  '';
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "terraria"
      "autoCreatedWorldSize"
    ] "Configure services.terraria.autocreate instead")
  ];
  options = {
    services.terraria = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If enabled, starts a Terraria server. The server can be connected to via `tmux -S ''${config.${opt.dataDir}}/terraria.sock attach`
          for administration by users who are a part of the `terraria` group (use `C-b d` shortcut to detach again).
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 7777;
        description = ''
          Specifies the port to listen on.
        '';
      };

      maxPlayers = lib.mkOption {
        type = lib.types.ints.u8;
        default = 255;
        description = ''
          Sets the max number of players (between 1 and 255).
        '';
      };

      password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Sets the server password. Leave `null` for no password.
        '';
      };

      messageOfTheDay = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Set the server message of the day text.
        '';
      };

      autocreate = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to auto-create a world if `worldPath` does not point to an existing world.
          '';
        };
        size = lib.mkOption {
          type = lib.types.enum (lib.attrNames worldSizeMap);
          default = "medium";
          description = ''
            Specifies the size of the auto-created world.
          '';
        };
        difficulty = lib.mkOption {
          type = lib.types.enum (lib.attrNames difficultyMap);
          default = "normal";
          description = ''
            Specifies the difficulty of the auto-created world.
          '';
        };
        seed = lib.mkOption {
          type = lib.types.nullOr (lib.types.enum (lib.attrNames difficultyMap));
          default = null;
          description = ''
            Specifies the seed of the auto-created world.
          '';
        };
      };

      worldPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The path to the world file (`.wld`) which should be loaded.
          If no world exists at this path, one will be created with the size
          specified by `autoCreatedWorldSize`.
        '';
      };

      banListPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The path to the ban list.
        '';
      };

      secure = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Adds additional cheat protection to the server.";
      };

      noUPnP = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disables automatic Universal Plug and Play.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open ports in the firewall";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/terraria";
        example = "/srv/terraria";
        description = "Path to variable state data directory for terraria.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.terraria = {
      description = "Terraria server service user";
      group = "terraria";
      home = cfg.dataDir;
      createHome = true;
      uid = config.ids.uids.terraria;
    };

    users.groups.terraria = {
      gid = config.ids.gids.terraria;
    };

    systemd.services.terraria = {
      description = "Terraria Server Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = "terraria";
        Group = "terraria";
        Type = "forking";
        GuessMainPID = true;
        UMask = "007";
        ExecStart = "${tmuxCmd} new -d ${pkgs.terraria-server}/bin/TerrariaServer -config ${configFile}";
        ExecStop = "${stopScript} $MAINPID";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

  };
}
