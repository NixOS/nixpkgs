{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg   = config.services.terraria;
  opt   = options.services.terraria;
  worldSizeMap = { small = 1; medium = 2; large = 3; };
  valFlag = name: val: optionalString (val != null) "-${name} \"${escape ["\\" "\""] (toString val)}\"";
  boolFlag = name: val: optionalString val "-${name}";
  flags = [
    (valFlag "port" cfg.port)
    (valFlag "maxPlayers" cfg.maxPlayers)
    (valFlag "password" cfg.password)
    (valFlag "motd" cfg.messageOfTheDay)
    (valFlag "world" cfg.worldPath)
    (valFlag "autocreate" (builtins.getAttr cfg.autoCreatedWorldSize worldSizeMap))
    (valFlag "banlist" cfg.banListPath)
    (boolFlag "secure" cfg.secure)
    (boolFlag "noupnp" cfg.noUPnP)
  ];
  stopScript = pkgs.writeScript "terraria-stop" ''
    #!${pkgs.runtimeShell}

    if ! [ -d "/proc/$1" ]; then
      exit 0
    fi

    ${getBin pkgs.tmux}/bin/tmux -S ${cfg.dataDir}/terraria.sock send-keys Enter exit Enter
    ${getBin pkgs.coreutils}/bin/tail --pid="$1" -f /dev/null
  '';
in
{
  options = {
    services.terraria = {
      enable = mkOption {
        type        = types.bool;
        default     = false;
        description = lib.mdDoc ''
          If enabled, starts a Terraria server. The server can be connected to via `tmux -S ''${config.${opt.dataDir}}/terraria.sock attach`
          for administration by users who are a part of the `terraria` group (use `C-b d` shortcut to detach again).
        '';
      };

      port = mkOption {
        type        = types.port;
        default     = 7777;
        description = lib.mdDoc ''
          Specifies the port to listen on.
        '';
      };

      maxPlayers = mkOption {
        type        = types.ints.u8;
        default     = 255;
        description = lib.mdDoc ''
          Sets the max number of players (between 1 and 255).
        '';
      };

      password = mkOption {
        type        = types.nullOr types.str;
        default     = null;
        description = lib.mdDoc ''
          Sets the server password. Leave `null` for no password.
        '';
      };

      messageOfTheDay = mkOption {
        type        = types.nullOr types.str;
        default     = null;
        description = lib.mdDoc ''
          Set the server message of the day text.
        '';
      };

      worldPath = mkOption {
        type        = types.nullOr types.path;
        default     = null;
        description = lib.mdDoc ''
          The path to the world file (`.wld`) which should be loaded.
          If no world exists at this path, one will be created with the size
          specified by `autoCreatedWorldSize`.
        '';
      };

      autoCreatedWorldSize = mkOption {
        type        = types.enum [ "small" "medium" "large" ];
        default     = "medium";
        description = lib.mdDoc ''
          Specifies the size of the auto-created world if `worldPath` does not
          point to an existing world.
        '';
      };

      banListPath = mkOption {
        type        = types.nullOr types.path;
        default     = null;
        description = lib.mdDoc ''
          The path to the ban list.
        '';
      };

      secure = mkOption {
        type        = types.bool;
        default     = false;
        description = lib.mdDoc "Adds additional cheat protection to the server.";
      };

      noUPnP = mkOption {
        type        = types.bool;
        default     = false;
        description = lib.mdDoc "Disables automatic Universal Plug and Play.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Wheter to open ports in the firewall";
      };

      dataDir = mkOption {
        type        = types.str;
        default     = "/var/lib/terraria";
        example     = "/srv/terraria";
        description = lib.mdDoc "Path to variable state data directory for terraria.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.terraria = {
      description = "Terraria server service user";
      home        = cfg.dataDir;
      createHome  = true;
      uid         = config.ids.uids.terraria;
    };

    users.groups.terraria = {
      gid = config.ids.gids.terraria;
      members = [ "terraria" ];
    };

    systemd.services.terraria = {
      description   = "Terraria Server Service";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      serviceConfig = {
        User    = "terraria";
        Type = "forking";
        GuessMainPID = true;
        ExecStart = "${getBin pkgs.tmux}/bin/tmux -S ${cfg.dataDir}/terraria.sock new -d ${pkgs.terraria-server}/bin/TerrariaServer ${concatStringsSep " " flags}";
        ExecStop = "${stopScript} $MAINPID";
      };

      postStart = ''
        ${pkgs.coreutils}/bin/chmod 660 ${cfg.dataDir}/terraria.sock
        ${pkgs.coreutils}/bin/chgrp terraria ${cfg.dataDir}/terraria.sock
      '';
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

  };
}
