{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.botamusique;

  format = pkgs.formats.ini {};
  configFile = format.generate "botamusique.ini" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [ hexa ];

  options.services.botamusique = {
    enable = mkEnableOption "botamusique, a bot to play audio streams on mumble";

    package = mkPackageOption pkgs "botamusique" { };

    settings = mkOption {
      type = with types; submodule {
        freeformType = format.type;
        options = {
          server.host = mkOption {
            type = types.str;
            default = "localhost";
            example = "mumble.example.com";
            description = "Hostname of the mumble server to connect to.";
          };

          server.port = mkOption {
            type = types.port;
            default = 64738;
            description = "Port of the mumble server to connect to.";
          };

          bot.username = mkOption {
            type = types.str;
            default = "botamusique";
            description = "Name the bot should appear with.";
          };

          bot.comment = mkOption {
            type = types.str;
            default = "Hi, I'm here to play radio, local music or youtube/soundcloud music. Have fun!";
            description = "Comment displayed for the bot.";
          };
        };
      };
      default = {};
      description = ''
        Your {file}`configuration.ini` as a Nix attribute set. Look up
        possible options in the [configuration.example.ini](https://github.com/azlux/botamusique/blob/master/configuration.example.ini).
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.botamusique = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig.Documentation = "https://github.com/azlux/botamusique/wiki";

      environment.HOME = "/var/lib/botamusique";

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/botamusique --config ${configFile}";
        Restart = "always"; # the bot exits when the server connection is lost

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DynamicUser = true;
        IPAddressDeny = [
          "link-local"
          "multicast"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        ProcSubset = "pid";
        PrivateDevices = true;
        PrivateUsers = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        StateDirectory = "botamusique";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @resources"
          "~@privileged"
        ];
        UMask = "0077";
        WorkingDirectory = "/var/lib/botamusique";
      };
    };
  };
}
