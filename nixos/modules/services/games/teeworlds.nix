{ config, lib, pkgs, ... }:
let
  cfg = config.services.teeworlds;
  register = cfg.register;

  bool = b: if b != null && b then "1" else "0";
  optionalSetting = s: setting: lib.optionalString (s != null) "${setting} ${s}";
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

    ${lib.concatStringsSep "\n" cfg.extraOptions}
  '';

in
{
  options = {
    services.teeworlds = {
      enable = lib.mkEnableOption "Teeworlds Server";

      package = lib.mkPackageOption pkgs "teeworlds-server" { };

      openPorts = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open firewall ports for Teeworlds.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "unnamed server";
        description = ''
          Name of the server.
        '';
      };

      register = lib.mkOption {
        type = lib.types.bool;
        example = true;
        default = false;
        description = ''
          Whether the server registers as a public server in the global server list. This is disabled by default for privacy reasons.
        '';
      };

      motd = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The server's message of the day text.
        '';
      };

      password = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Password to connect to the server.
        '';
      };

      rconPassword = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Password to access the remote console. If not set, a randomly generated one is displayed in the server log.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8303;
        description = ''
          Port the server will listen on.
        '';
      };

      extraOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Extra configuration lines for the {file}`teeworlds.cfg`. See [Teeworlds Documentation](https://www.teeworlds.com/?page=docs&wiki=server_settings).
        '';
        example = [ "sv_map dm1" "sv_gametype dm" ];
      };

      server = {
        bindAddr = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            The address the server will bind to.
          '';
        };

        enableHighBandwidth = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to enable high bandwidth mode on LAN servers. This will double the amount of bandwidth required for running the server.
          '';
        };

        hostName = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Hostname for the server.
          '';
        };

        inactivePenalty = lib.mkOption {
          type = lib.types.enum [ "spectator" "spectator/kick" "kick" ];
          example = "spectator";
          default = "spectator/kick";
          description = ''
            Specify what to do when a client goes inactive (see [](#opt-services.teeworlds.server.inactiveTime)).

            - `spectator`: send the client into spectator mode

            - `spectator/kick`: send the client into a free spectator slot, otherwise kick the client

            - `kick`: kick the client
          '';
        };

        kickInactiveSpectators = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to kick inactive spectators.
          '';
        };

        inactiveTime = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 3;
          description = ''
            The amount of minutes a client has to idle before it is considered inactive.
          '';
        };

        maxClients = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 12;
          description = ''
            The maximum amount of clients that can be connected to the server at the same time.
          '';
        };

        maxClientsPerIP = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 12;
          description = ''
            The maximum amount of clients with the same IP address that can be connected to the server at the same time.
          '';
        };

        skillLevel = lib.mkOption {
          type = lib.types.enum [ "casual" "normal" "competitive" ];
          default = "normal";
          description = ''
            The skill level shown in the server browser.
          '';
        };

        enableSpamProtection = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to enable chat spam protection.
          '';
        };
      };

      game = {
        gameType = lib.mkOption {
          type = lib.types.str;
          example = "ctf";
          default = "dm";
          description = ''
            The game type to use on the server.

            The default gametypes are `dm`, `tdm`, `ctf`, `lms`, and `lts`.
          '';
        };

        map = lib.mkOption {
          type = lib.types.str;
          example = "ctf5";
          default = "dm1";
          description = ''
            The map to use on the server.
          '';
        };

        swapTeams = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to swap teams each round.
          '';
        };

        enableReadyMode = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to enable "ready mode"; where players can pause/unpause the game
            and start the game in warmup, using their ready state.
          '';
        };

        playerSlots = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 8;
          description = ''
            The amount of slots to reserve for players (as opposed to spectators).
          '';
        };

        enablePowerups = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to allow powerups such as the ninja.
          '';
        };

        scoreLimit = lib.mkOption {
          type = lib.types.ints.unsigned;
          example = 400;
          default = 20;
          description = ''
            The score limit needed to win a round.
          '';
        };

        restrictSpectators = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to restrict access to information such as health, ammo and armour in spectator mode.
          '';
        };

        enableTeamDamage = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to enable team damage; whether to allow team mates to inflict damage on one another.
          '';
        };

        timeLimit = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 0;
          description = ''
            Time limit of the game. In cases of equal points, there will be sudden death.
            Setting this to 0 disables a time limit.
          '';
        };

        tournamentMode = lib.mkOption {
          type = lib.types.enum [ "disable" "enable" "restrictSpectators" ];
          default = "disable";
          description = ''
            Whether to enable tournament mode. In tournament mode, players join as spectators.
            If this is set to `restrictSpectators`, tournament mode is enabled but spectator chat is restricted.
          '';
        };

        enableVoteKick = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to enable voting to kick players.
          '';
        };

        voteKickBanTime = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 5;
          description = ''
            The amount of minutes that a player is banned for if they get kicked by a vote.
          '';
        };

        voteKickMinimumPlayers = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 5;
          description = ''
            The minimum amount of players required to start a kick vote.
          '';
        };
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/teeworlds/teeworlds.env";
        description = ''
          Environment file as defined in {manpage}`systemd.exec(5)`.

          Secrets may be passed to the service without adding them to the world-readable
          Nix store, by specifying placeholder variables as the option value in Nix and
          setting these variables accordingly in the environment file.

          ```
            # snippet of teeworlds-related config
            services.teeworlds.password = "$TEEWORLDS_PASSWORD";
          ```

          ```
            # content of the environment file
            TEEWORLDS_PASSWORD=verysecretpassword
          ```

          Note that this file needs to be available on the host on which
          `teeworlds` is running.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openPorts {
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.services.teeworlds = {
      description = "Teeworlds Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectory = "teeworlds";
        RuntimeDirectoryMode = "0700";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        ExecStartPre = ''
          ${pkgs.envsubst}/bin/envsubst \
            -i ${teeworldsConf} \
            -o /run/teeworlds/teeworlds.yaml
        '';
        ExecStart = "${lib.getExe cfg.package} -f /run/teeworlds/teeworlds.yaml";

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
