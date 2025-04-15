{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mchprs;
  settingsFormat = pkgs.formats.toml { };

  whitelistFile = pkgs.writeText "whitelist.json" (
    builtins.toJSON (
      lib.mapAttrsToList (n: v: {
        name = n;
        uuid = v;
      }) cfg.whitelist.list
    )
  );

  configToml =
    (removeAttrs cfg.settings [
      "address"
      "port"
    ])
    // {
      bind_address = cfg.settings.address + ":" + toString cfg.settings.port;
      whitelist = cfg.whitelist.enable;
    };

  configTomlFile = settingsFormat.generate "Config.toml" configToml;
in
{
  options = {
    services.mchprs = {
      enable = lib.mkEnableOption "MCHPRS, a Minecraft server";

      declarativeSettings = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to use a declarative configuration for MCHPRS.
        '';
      };

      declarativeWhitelist = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to use a declarative whitelist.
          The options {option}`services.mchprs.whitelist.list`
          will be applied if and only if set to `true`.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/mchprs";
        description = ''
          Directory to store MCHPRS database and other state/data files.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for the server.
          Only has effect when
          {option}`services.mchprs.declarativeSettings` is `true`.
        '';
      };

      maxRuntime = lib.mkOption {
        type = lib.types.str;
        default = "infinity";
        example = "7d";
        description = ''
          Automatically restart the server after
          {option}`services.mchprs.maxRuntime`.
          The {manpage}`systemd.time(7)` time span format is described here:
          <https://www.freedesktop.org/software/systemd/man/systemd.time.html#Parsing%20Time%20Spans>.
          If `null`, then the server is not restarted automatically.
        '';
      };

      package = lib.mkPackageOption pkgs "mchprs" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options = {
            port = lib.mkOption {
              type = lib.types.port;
              default = 25565;
              description = ''
                Port for the server.
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };

            address = lib.mkOption {
              type = lib.types.str;
              default = "0.0.0.0";
              description = ''
                Address for the server.
                Please use enclosing square brackets when using ipv6.
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };

            motd = lib.mkOption {
              type = lib.types.str;
              default = "Minecraft High Performance Redstone Server";
              description = ''
                Message of the day.
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };

            chat_format = lib.mkOption {
              type = lib.types.str;
              default = "<{username}> {message}";
              description = ''
                How to format chat message interpolating `username`
                and `message` with curly braces.
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };

            max_players = lib.mkOption {
              type = lib.types.ints.positive;
              default = 99999;
              description = ''
                Maximum number of simultaneous players.
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };

            view_distance = lib.mkOption {
              type = lib.types.ints.positive;
              default = 8;
              description = ''
                Maximal distance (in chunks) between players and loaded chunks.
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };

            bungeecord = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Enable compatibility with
                [BungeeCord](https://github.com/SpigotMC/BungeeCord).
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };

            schemati = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Mimic the verification and directory layout used by the
                Open Redstone Engineers
                [Schemati plugin](https://github.com/OpenRedstoneEngineers/Schemati).
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };

            block_in_hitbox = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Allow placing blocks inside of players
                (hitbox logic is simplified).
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };

            auto_redpiler = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Use redpiler automatically.
                Only has effect when
                {option}`services.mchprs.declarativeSettings` is `true`.
              '';
            };
          };
        };
        default = { };

        description = ''
          Configuration for MCHPRS via `Config.toml`.
          See https://github.com/MCHPR/MCHPRS/blob/master/README.md for documentation.
        '';
      };

      whitelist = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether or not the whitelist (in `whitelist.json`) shoud be enabled.
            Only has effect when {option}`services.mchprs.declarativeSettings` is `true`.
          '';
        };

        list = lib.mkOption {
          type =
            let
              minecraftUUID =
                lib.types.strMatching "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
                // {
                  description = "Minecraft UUID";
                };
            in
            lib.types.attrsOf minecraftUUID;
          default = { };
          example = lib.literalExpression ''
            {
              username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
              username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
            };
          '';
          description = ''
            Whitelisted players, only has an effect when
            {option}`services.mchprs.declarativeWhitelist` is
            `true` and the whitelist is enabled
            via {option}`services.mchprs.whitelist.enable`.
            This is a mapping from Minecraft usernames to UUIDs.
            You can use <https://mcuuid.net/> to get a
            Minecraft UUID for a username.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.mchprs = {
      description = "MCHPRS service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "mchprs";
    };
    users.groups.mchprs = { };

    systemd.services.mchprs = {
      description = "MCHPRS Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        RuntimeMaxSec = cfg.maxRuntime;
        User = "mchprs";
        WorkingDirectory = cfg.dataDir;

        StandardOutput = "journal";
        StandardError = "journal";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };

      preStart =
        (
          if cfg.declarativeSettings then
            ''
              if [ -e .declarativeSettings ]; then

                # Settings were declarative before, no need to back up anything
                cp -f ${configTomlFile} Config.toml

              else

                # Declarative settings for the first time, backup stateful files
                cp -b --suffix=.stateful ${configTomlFile} Config.toml

                echo "Autogenerated file that implies that this server configuration is managed declaratively by NixOS" \
                  > .declarativeSettings

              fi
            ''
          else
            ''
              if [ -e .declarativeSettings ]; then
                rm .declarativeSettings
              fi
            ''
        )
        + (
          if cfg.declarativeWhitelist then
            ''
              if [ -e .declarativeWhitelist ]; then

                # Whitelist was declarative before, no need to back up anything
                ln -sf ${whitelistFile} whitelist.json

              else

                # Declarative whitelist for the first time, backup stateful files
                ln -sb --suffix=.stateful ${whitelistFile} whitelist.json

                echo "Autogenerated file that implies that this server's whitelist is managed declaratively by NixOS" \
                  > .declarativeWhitelist

              fi
            ''
          else
            ''
              if [ -e .declarativeWhitelist ]; then
                rm .declarativeWhitelist
              fi
            ''
        );
    };

    networking.firewall = lib.mkIf (cfg.declarativeSettings && cfg.openFirewall) {
      allowedUDPPorts = [ cfg.settings.port ];
      allowedTCPPorts = [ cfg.settings.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ gdd ];
}
