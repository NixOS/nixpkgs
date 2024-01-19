{ config, pkgs, lib, ... }:
with lib; let
  cfg = config.services.yuzu;
in {
  options = {
    services.yuzu = {
      enable = mkEnableOption "yuzu";

      package = mkOption {
        type = types.package;
        default = pkgs.yuzuPackages.mainline;
        defaultText = literalExpression "pkgs.yuzuPackages.mainline";
        example = literalExpression "pkgs.yuzuPackages.early-access";
        description = mdDoc ''
          Yuzu package version to use. This defaults to the mainline channel.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc ''
          Whether to automatically open the specified UDP port in the firewall.
        '';
      };

      secretsFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = literalExpression ''
          PASSWORD="123456"
          TOKEN="aBcDeF123..."
        '';
        description = mdDoc ''
          Systemd environment file containing yuzu options.
          Values defined here will override any values from the {option}`settings` options.
          The variable names are the same as the option names but in uppercase snakecase, example: "roomName" becomes "ROOM_NAME".
          This is useful when used with a secret management module like `sops-nix` or `agenix`.
        '';
      };

      settings = {
        # The order and the description of the options come from `yuzu-room --help`
        # The default option values come from the project itself

        roomName = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            The name of the room. Required.
          '';
        };

        roomDescription = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            The room description.
          '';
        };

        bindAddress = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = mdDoc ''
            The bind address for the room.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 24872;
          description = mdDoc ''
            The port used for the room.
          '';
        };

        maxMembers = mkOption {
          type = types.ints.between 2 254;
          default = 16;
          description = mdDoc ''
            The maximum number of players for this room.
          '';
        };

        password = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            The password for the room.
            You can use {option}`secretsFile` to prevent having it in clear text in your config and your nix store.
          '';
        };

        preferredGame = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            The preferred game for this room. Required.
          '';
        };

        preferredGameId = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            The preferred game-id for this room.
          '';
        };

        token = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = mdDoc ''
            The token used for announce.
            You can use {option}`secretsFile` to prevent having it in clear text in your config and your nix store.
          '';
        };

        webApiUrl = mkOption {
          type = types.nullOr types.str;
          default = "https://api.yuzu-emu.org";
          description = mdDoc ''
            yuzu Web API url.
          '';
        };

        enableYuzuMods = mkOption {
          type = types.bool;
          default = false;
          description = mdDoc ''
            Allow yuzu Community Moderators to moderate on your room.
          '';
        };
      };
    };
  };
  config = mkIf cfg.enable {
    assertions = [
      { assertion = !(isNull cfg.settings.roomName || isNull cfg.settings.preferredGame);
        message = "'services.yuzu.settings.roomName' and 'services.yuzu.settings.preferredGame' are required";
      }
    ];

    networking.firewall.allowedUDPPorts = optional cfg.openFirewall cfg.settings.port;

    systemd.services.yuzu-multiplayer = {
      description = "Yuzu multiplayer server";
      wantedBy = ["multi-user.target"];
      after = [ "network.target" "network-online.target"];

      serviceConfig = {
        Restart = "always";
        DynamicUser = true;
        EnvironmentFile = mkIf (! isNull cfg.secretsFile) cfg.secretsFile;
        ExecStart = let
          # if the option is set, create a line that sets a default value to its corresponding environment vriable. At runtime, this env var might already be set by `secretsFile`
          f = o: ev: lib.optional (! isNull cfg.settings.${o}) ": \${${ev}:=\"${toString cfg.settings.${o}}\"}";
          options_as_env_vars = []
            ++ f "roomName"        "ROOM_NAME"
            ++ f "roomDescription" "ROOM_DESCRIPTION"
            ++ f "bindAddress"     "BIND_ADDRESS"
            ++ f "port"            "PORT"
            ++ f "maxMembers"      "MAX_MEMBERS"
            ++ f "password"        "PASSWORD"
            ++ f "preferredGame"   "PREFERRED_GAME"
            ++ f "preferredGameId" "PREFERRED_GAME_ID"
            ++ f "token"           "TOKEN"
            ++ f "webApiUrl"       "WEB_API_URL"
            ++ f "enableYuzuMods"  "ENABLE_YUZU_MODS"
        ;
        in pkgs.writeShellScript "exec-script" ''

          ${lib.concatStringsSep "\n" options_as_env_vars}

          ARGS=()
          [[ -n $ROOM_NAME ]]         && ARGS+=("--room-name=$ROOM_NAME")
          [[ -n $ROOM_DESCRIPTION ]]  && ARGS+=("--room-description=$ROOM_DESCRIPTION")
          [[ -n $BIND_ADDRESS ]]      && ARGS+=("--bind-address=$BIND_ADDRESS")
          [[ -n $PORT ]]              && ARGS+=("--port=$PORT")
          [[ -n $MAX_MEMBERS ]]       && ARGS+=("--max_members=$MAX_MEMBERS")
          [[ -n $PASSWORD ]]          && ARGS+=("--password=$PASSWORD")
          [[ -n $PREFERRED_GAME ]]    && ARGS+=("--preferred-game=$PREFERRED_GAME")
          [[ -n $PREFERRED_GAME_ID ]] && ARGS+=("--preferred-game-id=$PREFERRED_GAME_ID")
          [[ -n $TOKEN ]]             && ARGS+=("--token=$TOKEN")
          [[ -n $WEB_API_URL ]]       && ARGS+=("--web-api-url=$WEB_API_URL")
          [[ -n $ENABLE_YUZU_MODS ]]  && ARGS+=("--enable-yuzu-mods")

          exec ${cfg.package}/bin/yuzu-room "''${ARGS[@]}"
        '';

        # Sandboxing
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        RestrictRealtime = true;
        RestrictNamespaces = true;
        MemoryDenyWriteExecute = true;

      };
    };
  };
}
