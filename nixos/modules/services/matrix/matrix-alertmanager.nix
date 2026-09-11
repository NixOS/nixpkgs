{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.matrix-alertmanager;
  rooms = room: lib.concatStringsSep "/" (room.receivers ++ [ room.roomId ]);
  concatenatedRooms = lib.concatStringsSep "|" (map rooms cfg.matrixRooms);
in
{
  meta.maintainers = [ lib.maintainers.erethon ];

  options.services.matrix-alertmanager = {
    enable = lib.mkEnableOption "matrix-alertmanager";
    package = lib.mkPackageOption pkgs "matrix-alertmanager" { };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port that matrix-alertmanager listens on.";
    };
    homeserverUrl = lib.mkOption {
      type = lib.types.str;
      description = "URL of the Matrix homeserver to use.";
      example = "https://matrix.example.com";
    };
    matrixUser = lib.mkOption {
      type = lib.types.str;
      description = "Matrix user to use for the bot.";
      example = "@alertmanageruser:example.com";
    };
    matrixRooms = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            receivers = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "List of receivers for this room";
            };
            roomId = lib.mkOption {
              type = lib.types.str;
              description = "Matrix room ID";
              apply =
                x:
                assert lib.assertMsg (lib.hasPrefix "!" x) "Matrix room ID must start with a '!'. Got: ${x}";
                x;
            };
          };
        }
      );
      description = ''
        Combination of Alertmanager receiver(s) and rooms for the bot to join.
        Each Alertmanager receiver can be mapped to post to a matrix room.

        Note, you must use a room ID and not a room alias/name. Room IDs start
        with a "!".
      '';
      example = [
        {
          receivers = [
            "receiver1"
            "receiver2"
          ];
          roomId = "!roomid@example.com";
        }
        {
          receivers = [ "receiver3" ];
          roomId = "!differentroomid@example.com";
        }
      ];
    };
    mention = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Makes the bot mention @room when posting an alert";
    };
    tokenFile = lib.mkOption {
      type = lib.types.externalPath;
      description = "File that contains a valid Matrix token for the Matrix user.";
    };
    secretFile = lib.mkOption {
      type = lib.types.externalPath;
      description = "File that contains a secret for the Alertmanager webhook.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.matrix-alertmanager = {
      description = "A bot to receive Alertmanager webhook events and forward them to chosen rooms.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        RestartSec = "10s";
        LoadCredential = [
          "token:${cfg.tokenFile}"
          "secret:${cfg.secretFile}"
        ];
      };

      environment = {
        APP_PORT = toString cfg.port;
        MATRIX_HOMESERVER_URL = cfg.homeserverUrl;
        MATRIX_ROOMS = concatenatedRooms;
        MATRIX_USER = cfg.matrixUser;
        MENTION_ROOM = if cfg.mention then "1" else "0";
        NODE_ENV = "production";
      };

      script = ''
        # shellcheck disable=SC2155
        export APP_ALERTMANAGER_SECRET=$(cat "''${CREDENTIALS_DIRECTORY}/secret")
        # shellcheck disable=SC2155
        export MATRIX_TOKEN=$(cat "''${CREDENTIALS_DIRECTORY}/token")
        exec ${lib.getExe cfg.package}
      '';
    };
  };
}
