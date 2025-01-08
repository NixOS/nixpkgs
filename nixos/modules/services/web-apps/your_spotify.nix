{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.your_spotify;

  configEnv = lib.concatMapAttrs (
    name: value:
    lib.optionalAttrs (value != null) {
      ${name} = if lib.isBool value then lib.boolToString value else toString value;
    }
  ) cfg.settings;

  configFile = pkgs.writeText "your_spotify.env" (
    lib.concatStrings (lib.mapAttrsToList (name: value: "${name}=${value}\n") configEnv)
  );
in
{
  options.services.your_spotify =
    {
      enable = lib.mkEnableOption "your_spotify";

      enableLocalDB = lib.mkEnableOption "a local mongodb instance";
      nginxVirtualHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          If set creates an nginx virtual host for the client.
          In most cases this should be the CLIENT_ENDPOINT without
          protocol prefix.
        '';
      };

      package = lib.mkPackageOption pkgs "your_spotify" { };

      clientPackage = lib.mkOption {
        type = lib.types.package;
        description = "Client package to use.";
      };

      spotifySecretFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          A file containing the secret key of your Spotify application.
          Refer to: [Creating the Spotify Application](https://github.com/Yooooomi/your_spotify#creating-the-spotify-application).
        '';
      };

      settings = lib.mkOption {
        description = ''
          Your Spotify Configuration. Refer to [Your Spotify](https://github.com/Yooooomi/your_spotify) for definitions and values.
        '';
        example = lib.literalExpression ''
          {
            CLIENT_ENDPOINT = "https://example.com";
            API_ENDPOINT = "https://api.example.com";
            SPOTIFY_PUBLIC = "spotify_client_id";
          }
        '';
        type = lib.types.submodule {
          freeformType = lib.types.attrsOf lib.types.str;
          options = {
            CLIENT_ENDPOINT = lib.mkOption {
              type = lib.types.str;
              description = ''
                The endpoint of your web application.
                Has to include a protocol Prefix (e.g. `http://`)
              '';
              example = "https://your_spotify.example.org";
            };
            API_ENDPOINT = lib.mkOption {
              type = lib.types.str;
              description = ''
                The endpoint of your server
                This api has to be reachable from the device you use the website from not from the server.
                This means that for example you may need two nginx virtual hosts if you want to expose this on the
                internet.
                Has to include a protocol Prefix (e.g. `http://`)
              '';
              example = "https://localhost:3000";
            };
            SPOTIFY_PUBLIC = lib.mkOption {
              type = lib.types.str;
              description = ''
                The public client ID of your Spotify application.
                Refer to: [Creating the Spotify Application](https://github.com/Yooooomi/your_spotify#creating-the-spotify-application)
              '';
            };
            MONGO_ENDPOINT = lib.mkOption {
              type = lib.types.str;
              description = ''The endpoint of the Mongo database.'';
              default = "mongodb://localhost:27017/your_spotify";
            };
            PORT = lib.mkOption {
              type = lib.types.port;
              description = "The port of the api server";
              default = 3000;
            };
          };
        };
      };
    };

  config = lib.mkIf cfg.enable {
    services.your_spotify.clientPackage = lib.mkDefault (
      cfg.package.client.override { apiEndpoint = cfg.settings.API_ENDPOINT; }
    );
    systemd.services.your_spotify = {
      after = [ "network.target" ];
      script = ''
        export SPOTIFY_SECRET=$(< "$CREDENTIALS_DIRECTORY/SPOTIFY_SECRET")
        ${lib.getExe' cfg.package "your_spotify_migrate"}
        exec ${lib.getExe cfg.package}
      '';
      serviceConfig = {
        User = "your_spotify";
        Group = "your_spotify";
        DynamicUser = true;
        EnvironmentFile = [ configFile ];
        StateDirectory = "your_spotify";
        LimitNOFILE = "1048576";
        PrivateTmp = true;
        PrivateDevices = true;
        StateDirectoryMode = "0700";
        Restart = "always";

        LoadCredential = [ "SPOTIFY_SECRET:${cfg.spotifySecretFile}" ];

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        #MemoryDenyWriteExecute = true; # Leads to coredump because V8 does JIT
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
        ];
        UMask = "0077";
      };
      wantedBy = [ "multi-user.target" ];
    };
    services.nginx = lib.mkIf (cfg.nginxVirtualHost != null) {
      enable = true;
      virtualHosts.${cfg.nginxVirtualHost} = {
        root = cfg.clientPackage;
        locations."/".extraConfig = ''
          add_header Content-Security-Policy "frame-ancestors 'none';" ;
          add_header X-Content-Type-Options "nosniff" ;
          try_files = $uri $uri/ /index.html ;
        '';
      };
    };
    services.mongodb = lib.mkIf cfg.enableLocalDB {
      enable = true;
    };
  };
  meta.maintainers = with lib.maintainers; [ patrickdag ];
}
