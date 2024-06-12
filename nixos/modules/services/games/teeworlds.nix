{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.teeworlds;
  register = cfg.register;

  bool = b: if b != null && b then "1" else "0";
  optionalSetting = s: setting: optionalString (s != null) "${setting} ${s}";
  lookup = attrs: key: default: if attrs ? key then attrs."${key}" else default;

  inactivePenaltyOptions = {
    "spectator" = "1";
    "spectator/kick" = "2";
    "kick" = "3";
  };
  skillLevelOptions = {
    "casual" = "0";
    "normal" = "1";
    "competitive" = "2";
  };
  tournamentModeOptions = {
    "disable" = "0";
    "enable"  = "1";
    "restrictSpectators" = "2";
  };

  teeworldsConf = pkgs.writeText "teeworlds.cfg" ''
    sv_port ${toString cfg.port}
    sv_register ${bool cfg.register}
    sv_name ${cfg.name}
    ${optionalSetting cfg.motd "sv_motd"}
    ${optionalSetting cfg.password "password"}
    ${optionalSetting cfg.rconPassword "sv_rcon_password"}

    ${optionalSetting cfg.server.bindAddr "bindaddr"}
    ${optionalSetting cfg.server.hostName "sv_hostname"}
    sv_high_bandwidth ${bool cfg.server.enableHighBandwidth}
    sv_inactivekick ${lookup inactivePenaltyOptions cfg.server.inactivePenalty "spectator/kick"}
    sv_inactivekick_spec ${bool cfg.server.kickInactiveSpectators}
    sv_inactivekick_time ${toString cfg.server.inactiveTime}
    sv_max_clients ${toString cfg.server.maxClients}
    sv_max_clients_per_ip ${toString cfg.server.maxClientsPerIP}
    sv_skill_level ${lookup skillLevelOptions cfg.server.skillLevel "normal"}
    sv_spamprotection ${bool cfg.server.enableSpamProtection}

    sv_gametype ${cfg.game.gameType}
    sv_map ${cfg.game.map}
    sv_match_swap ${bool cfg.game.swapTeams}
    sv_player_ready_mode ${bool cfg.game.enableReadyMode}
    sv_player_slots ${toString cfg.game.playerSlots}
    sv_powerups ${bool cfg.game.enablePowerups}
    sv_scorelimit ${toString cfg.game.scoreLimit}
    sv_strict_spectate_mode ${bool cfg.game.restrictSpectators}
    sv_teamdamage ${bool cfg.game.enableTeamDamage}
    sv_timelimit ${toString cfg.game.timeLimit}
    sv_tournament_mode ${lookup tournamentModeOptions cfg.server.tournamentMode "disable"}
    sv_vote_kick ${bool cfg.game.enableVoteKick}
    sv_vote_kick_bantime ${toString cfg.game.voteKickBanTime}
    sv_vote_kick_min ${toString cfg.game.voteKickMinimumPlayers}

    ${optionalSetting cfg.server.bindAddr "bindaddr"}
    ${optionalSetting cfg.server.hostName "sv_hostname"}
    sv_high_bandwidth ${bool cfg.server.enableHighBandwidth}
    sv_inactivekick ${lookup inactivePenaltyOptions cfg.server.inactivePenalty "spectator/kick"}
    sv_inactivekick_spec ${bool cfg.server.kickInactiveSpectators}
    sv_inactivekick_time ${toString cfg.server.inactiveTime}
    sv_max_clients ${toString cfg.server.maxClients}
    sv_max_clients_per_ip ${toString cfg.server.maxClientsPerIP}
    sv_skill_level ${lookup skillLevelOptions cfg.server.skillLevel "normal"}
    sv_spamprotection ${bool cfg.server.enableSpamProtection}

    sv_gametype ${cfg.game.gameType}
    sv_map ${cfg.game.map}
    sv_match_swap ${bool cfg.game.swapTeams}
    sv_player_ready_mode ${bool cfg.game.enableReadyMode}
    sv_player_slots ${toString cfg.game.playerSlots}
    sv_powerups ${bool cfg.game.enablePowerups}
    sv_scorelimit ${toString cfg.game.scoreLimit}
    sv_strict_spectate_mode ${bool cfg.game.restrictSpectators}
    sv_teamdamage ${bool cfg.game.enableTeamDamage}
    sv_timelimit ${toString cfg.game.timeLimit}
    sv_tournament_mode ${lookup tournamentModeOptions cfg.server.tournamentMode "disable"}
    sv_vote_kick ${bool cfg.game.enableVoteKick}
    sv_vote_kick_bantime ${toString cfg.game.voteKickBanTime}
    sv_vote_kick_min ${toString cfg.game.voteKickMinimumPlayers}

    ${concatStringsSep "\n" cfg.extraOptions}
  '';

in
{
  options = {
    services.teeworlds = {
      enable = mkEnableOption "Teeworlds Server";

      package = mkPackageOptionMD pkgs "teeworlds-server" { };

      openPorts = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open firewall ports for Teeworlds.";
      };

      name = mkOption {
        type = types.str;
        default = "unnamed server";
        description = ''
          Name of the server.
        '';
      };

      register = mkOption {
        type = types.bool;
        example = true;
        default = false;
        description = ''
          Whether the server registers as a public server in the global server list. This is disabled by default for privacy reasons.
        '';
      };

      motd = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The server's message of the day text.
        '';
      };

      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Password to connect to the server.
        '';
      };

      rconPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Password to access the remote console. If not set, a randomly generated one is displayed in the server log.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8303;
        description = ''
          Port the server will listen on.
        '';
      };

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra configuration lines for the {file}`teeworlds.cfg`. See [Teeworlds Documentation](https://www.teeworlds.com/?page=docs&wiki=server_settings).
        '';
        example = [ "sv_map dm1" "sv_gametype dm" ];
      };

      server = {
        bindAddr = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The address the server will bind to.
          '';
        };

        enableHighBandwidth = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable high bandwidth mode on LAN servers. This will double the amount of bandwidth required for running the server.
          '';
        };

        hostName = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Hostname for the server.
          '';
        };

        inactivePenalty = mkOption {
          type = types.enum [ "spectator" "spectator/kick" "kick" ];
          example = "spectator";
          default = "spectator/kick";
          description = ''
            Specify what to do when a client goes inactive (see [](#opt-services.teeworlds.server.inactiveTime)).

            - `spectator`: send the client into spectator mode

            - `spectator/kick`: send the client into a free spectator slot, otherwise kick the client

            - `kick`: kick the client
          '';
        };

        kickInactiveSpectators = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to kick inactive spectators.
          '';
        };

        inactiveTime = mkOption {
          type = types.ints.unsigned;
          default = 3;
          description = ''
            The amount of minutes a client has to idle before it is considered inactive.
          '';
        };

        maxClients = mkOption {
          type = types.ints.unsigned;
          default = 12;
          description = ''
            The maximum amount of clients that can be connected to the server at the same time.
          '';
        };

        maxClientsPerIP = mkOption {
          type = types.ints.unsigned;
          default = 12;
          description = ''
            The maximum amount of clients with the same IP address that can be connected to the server at the same time.
          '';
        };

        skillLevel = mkOption {
          type = types.enum [ "casual" "normal" "competitive" ];
          default = "normal";
          description = ''
            The skill level shown in the server browser.
          '';
        };

        enableSpamProtection = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to enable chat spam protection.
          '';
        };
      };

      game = {
        gameType = mkOption {
          type = types.str;
          example = "ctf";
          default = "dm";
          description = ''
            The game type to use on the server.

            The default gametypes are `dm`, `tdm`, `ctf`, `lms`, and `lts`.
          '';
        };

        map = mkOption {
          type = types.str;
          example = "ctf5";
          default = "dm1";
          description = ''
            The map to use on the server.
          '';
        };

        swapTeams = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to swap teams each round.
          '';
        };

        enableReadyMode = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable "ready mode"; where players can pause/unpause the game
            and start the game in warmup, using their ready state.
          '';
        };

        playerSlots = mkOption {
          type = types.ints.unsigned;
          default = 8;
          description = ''
            The amount of slots to reserve for players (as opposed to spectators).
          '';
        };

        enablePowerups = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to allow powerups such as the ninja.
          '';
        };

        scoreLimit = mkOption {
          type = types.ints.unsigned;
          example = 400;
          default = 20;
          description = ''
            The score limit needed to win a round.
          '';
        };

        restrictSpectators = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to restrict access to information such as health, ammo and armour in spectator mode.
          '';
        };

        enableTeamDamage = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable team damage; whether to allow team mates to inflict damage on one another.
          '';
        };

        timeLimit = mkOption {
          type = types.ints.unsigned;
          default = 0;
          description = ''
            Time limit of the game. In cases of equal points, there will be sudden death.
            Setting this to 0 disables a time limit.
          '';
        };

        tournamentMode = mkOption {
          type = types.enum [ "disable" "enable" "restrictSpectators" ];
          default = "disable";
          description = ''
            Whether to enable tournament mode. In tournament mode, players join as spectators.
            If this is set to `restrictSpectators`, tournament mode is enabled but spectator chat is restricted.
          '';
        };

        enableVoteKick = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to enable voting to kick players.
          '';
        };

        voteKickBanTime = mkOption {
          type = types.ints.unsigned;
          default = 5;
          description = ''
            The amount of minutes that a player is banned for if they get kicked by a vote.
          '';
        };

        voteKickMinimumPlayers = mkOption {
          type = types.ints.unsigned;
          default = 5;
          description = ''
            The minimum amount of players required to start a kick vote.
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openPorts {
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.services.teeworlds = {
      description = "Teeworlds Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/teeworlds_srv -f ${teeworldsConf}";

        # Hardening
        CapabilityBoundingSet = false;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
      };
    };
  };
}
