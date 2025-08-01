{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    boolToString
    concatMapAttrs
    concatStrings
    isBool
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalAttrs
    types
    mkDefault
    ;
  cfg = config.services.your_spotify;

  configEnv = concatMapAttrs (
    name: value:
    optionalAttrs (value != null) {
      ${name} = if isBool value then boolToString value else toString value;
    }
  ) cfg.settings;

  configFile = pkgs.writeText "your_spotify.env" (
    concatStrings (mapAttrsToList (name: value: "${name}=${value}\n") configEnv)
  );
in
{
  options.services.your_spotify =
    let
      inherit (types)
        nullOr
        port
        str
        path
        package
        ;
    in
    {
      enable = mkEnableOption "your_spotify";

      enableLocalDB = mkEnableOption "a local mongodb instance";
      nginxVirtualHost = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          If set creates an nginx virtual host for the client.
          In most cases this should be the CLIENT_ENDPOINT without
          protocol prefix.
        '';
      };

      package = mkPackageOption pkgs "your_spotify" { };

      clientPackage = mkOption {
        type = package;
        description = "Client package to use.";
      };

      spotifySecretFile = mkOption {
        type = path;
        description = ''
          A file containing the secret key of your Spotify application.
          Refer to: [Creating the Spotify Application](https://github.com/Yooooomi/your_spotify#creating-the-spotify-application).
        '';
      };

      settings = mkOption {
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
        type = types.submodule {
          freeformType = types.attrsOf types.str;
          options = {
            CLIENT_ENDPOINT = mkOption {
              type = str;
              description = ''
                The endpoint of your web application.
                Has to include a protocol Prefix (e.g. `http://`)
              '';
              example = "https://your_spotify.example.org";
            };
            API_ENDPOINT = mkOption {
              type = str;
              description = ''
                The endpoint of your server
                This api has to be reachable from the device you use the website from not from the server.
                This means that for example you may need two nginx virtual hosts if you want to expose this on the
                internet.
                Has to include a protocol Prefix (e.g. `http://`)
              '';
              example = "https://localhost:3000";
            };
            SPOTIFY_PUBLIC = mkOption {
              type = str;
              description = ''
                The public client ID of your Spotify application.
                Refer to: [Creating the Spotify Application](https://github.com/Yooooomi/your_spotify#creating-the-spotify-application)
              '';
            };
            MONGO_ENDPOINT = mkOption {
              type = str;
              description = ''The endpoint of the Mongo database.'';
              default = "mongodb://localhost:27017/your_spotify";
            };
            PORT = mkOption {
              type = port;
              description = "The port of the api server";
              default = 3000;
            };
          };
        };
      };
    };

  config = mkIf cfg.enable {
    services.your_spotify.clientPackage = mkDefault (
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
    services.nginx = mkIf (cfg.nginxVirtualHost != null) {
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
    services.mongodb = mkIf cfg.enableLocalDB {
      enable = true;
    };
  };
  meta.maintainers = with lib.maintainers; [ patrickdag ];
}
