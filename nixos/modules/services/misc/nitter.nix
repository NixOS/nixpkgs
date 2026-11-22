{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nitter;
  configFile = pkgs.writeText "nitter.conf" ''
    ${lib.generators.toINI
      {
        # String values need to be quoted
        mkKeyValue = lib.generators.mkKeyValueDefault {
          mkValueString =
            v:
            if lib.isString v then
              "\"" + (lib.escape [ "\"" ] (toString v)) + "\""
            else
              lib.generators.mkValueStringDefault { } v;
        } " = ";
      }
      (
        lib.recursiveUpdate {
          Server = cfg.server;
          Cache = cfg.cache;
          Config = cfg.config // {
            hmacKey = "@hmac@";
          };
          Preferences = cfg.preferences;
        } cfg.settings
      )
    }
  '';
  # `hmac` is a secret used for cryptographic signing of video URLs.
  # Generate it on first launch, then copy configuration and replace
  # `@hmac@` with this value.
  # We are not using sed as it would leak the value in the command line.
  preStart = pkgs.writers.writePython3 "nitter-prestart" { } ''
    import os
    import secrets

    state_dir = os.environ.get("STATE_DIRECTORY")
    if not os.path.isfile(f"{state_dir}/hmac"):
        # Generate hmac on first launch
        hmac = secrets.token_hex(32)
        with open(f"{state_dir}/hmac", "w") as f:
            f.write(hmac)
    else:
        # Load previously generated hmac
        with open(f"{state_dir}/hmac", "r") as f:
            hmac = f.read()

    configFile = "${configFile}"
    with open(configFile, "r") as f_in:
        with open(f"{state_dir}/nitter.conf", "w") as f_out:
            f_out.write(f_in.read().replace("@hmac@", hmac))
  '';
in
{
  imports = [
    # https://github.com/zedeus/nitter/pull/772
    (lib.mkRemovedOptionModule [
      "services"
      "nitter"
      "replaceInstagram"
    ] "Nitter no longer supports this option as Bibliogram has been discontinued.")
    (lib.mkRenamedOptionModule
      [ "services" "nitter" "guestAccounts" ]
      [ "services" "nitter" "sessionsFile" ]
    )
  ];

  options = {
    services.nitter = {
      enable = lib.mkEnableOption "Nitter, an alternative Twitter front-end";

      package = lib.mkPackageOption pkgs "nitter" { };

      server = {
        address = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          example = "127.0.0.1";
          description = "The address to listen on.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
          example = 8000;
          description = "The port to listen on.";
        };

        https = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Set secure attribute on cookies. Keep it disabled to enable cookies when not using HTTPS.";
        };

        httpMaxConnections = lib.mkOption {
          type = lib.types.int;
          default = 100;
          description = "Maximum number of HTTP connections.";
        };

        staticDir = lib.mkOption {
          type = lib.types.path;
          default = "${cfg.package}/share/nitter/public";
          defaultText = lib.literalExpression ''"''${config.services.nitter.package}/share/nitter/public"'';
          description = "Path to the static files directory.";
        };

        title = lib.mkOption {
          type = lib.types.str;
          default = "nitter";
          description = "Title of the instance.";
        };

        hostname = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          example = "nitter.net";
          description = "Hostname of the instance.";
        };
      };

      cache = {
        listMinutes = lib.mkOption {
          type = lib.types.int;
          default = 240;
          description = "How long to cache list info (not the tweets, so keep it high).";
        };

        rssMinutes = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = "How long to cache RSS queries.";
        };

        redisHost = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = "Redis host.";
        };

        redisPort = lib.mkOption {
          type = lib.types.port;
          default = 6379;
          description = "Redis port.";
        };

        redisConnections = lib.mkOption {
          type = lib.types.int;
          default = 20;
          description = "Redis connection pool size.";
        };

        redisMaxConnections = lib.mkOption {
          type = lib.types.int;
          default = 30;
          description = ''
            Maximum number of connections to Redis.

            New connections are opened when none are available, but if the
            pool size goes above this, they are closed when released, do not
            worry about this unless you receive tons of requests per second.
          '';
        };
      };

      config = {
        base64Media = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use base64 encoding for proxied media URLs.";
        };

        enableRSS = lib.mkEnableOption "RSS feeds" // {
          default = true;
        };

        enableDebug = lib.mkEnableOption "request logs and debug endpoints";

        proxy = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "URL to a HTTP/HTTPS proxy.";
        };

        proxyAuth = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Credentials for proxy.";
        };

        tokenCount = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = ''
            Minimum amount of usable tokens.

            Tokens are used to authorize API requests, but they expire after
            ~1 hour, and have a limit of 187 requests. The limit gets reset
            every 15 minutes, and the pool is filled up so there is always at
            least tokenCount usable tokens. Only increase this if you receive
            major bursts all the time.
          '';
        };
      };

      preferences = {
        replaceTwitter = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "nitter.net";
          description = "Replace Twitter links with links to this instance (blank to disable).";
        };

        replaceYouTube = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "piped.kavin.rocks";
          description = "Replace YouTube links with links to this instance (blank to disable).";
        };

        replaceReddit = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "teddit.net";
          description = "Replace Reddit links with links to this instance (blank to disable).";
        };

        mp4Playback = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable MP4 video playback.";
        };

        hlsPlayback = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable HLS video streaming (requires JavaScript).";
        };

        proxyVideos = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Proxy video streaming through the server (might be slow).";
        };

        muteVideos = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Mute videos by default.";
        };

        autoplayGifs = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Autoplay GIFs.";
        };

        theme = lib.mkOption {
          type = lib.types.str;
          default = "Nitter";
          description = "Instance theme.";
        };

        infiniteScroll = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Infinite scrolling (requires JavaScript, experimental!).";
        };

        stickyProfile = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Make profile sidebar stick to top.";
        };

        bidiSupport = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Support bidirectional text (makes clicking on tweets harder).";
        };

        hideTweetStats = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Hide tweet stats (replies, retweets, likes).";
        };

        hideBanner = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Hide profile banner.";
        };

        hidePins = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Hide pinned tweets.";
        };

        hideReplies = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Hide tweet replies.";
        };

        squareAvatars = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Square profile pictures.";
        };
      };

      settings = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = ''
          Add settings here to override NixOS module generated settings.

          Check the official repository for the available settings:
          <https://github.com/zedeus/nitter/blob/master/nitter.example.conf>
        '';
      };

      sessionsFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/nitter/sessions.jsonl";
        description = ''
          Path to the session tokens file.

          This file contains a list of session tokens that can be used to
          access the instance without logging in. The file is in JSONL format,
          where each line is a JSON object with the following fields:

          {"oauth_token":"some_token","oauth_token_secret":"some_secret_key"}

          See <https://github.com/zedeus/nitter/wiki/Creating-session-tokens>
          for more information on session tokens and how to generate them.
        '';
      };

      redisCreateLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Configure local Redis server for Nitter.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for Nitter web interface.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          !cfg.redisCreateLocally || (cfg.cache.redisHost == "localhost" && cfg.cache.redisPort == 6379);
        message = "When services.nitter.redisCreateLocally is enabled, you need to use localhost:6379 as a cache server.";
      }
    ];

    systemd.services.nitter = {
      description = "Nitter (An alternative Twitter front-end)";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        DynamicUser = true;
        LoadCredential = "sessionsFile:${cfg.sessionsFile}";
        StateDirectory = "nitter";
        Environment = [
          "NITTER_CONF_FILE=/var/lib/nitter/nitter.conf"
          "NITTER_SESSIONS_FILE=%d/sessionsFile"
        ];
        # Some parts of Nitter expect `public` folder in working directory,
        # see https://github.com/zedeus/nitter/issues/414
        WorkingDirectory = "${cfg.package}/share/nitter";
        ExecStart = "${cfg.package}/bin/nitter";
        ExecStartPre = "${preStart}";
        AmbientCapabilities = lib.mkIf (cfg.server.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        Restart = "on-failure";
        RestartSec = "5s";
        # Hardening
        CapabilityBoundingSet = if (cfg.server.port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        # A private user cannot have process capabilities on the host's user
        # namespace and thus CAP_NET_BIND_SERVICE has no effect.
        PrivateUsers = (cfg.server.port >= 1024);
        ProcSubset = "pid";
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
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };

    services.redis.servers.nitter = lib.mkIf (cfg.redisCreateLocally) {
      enable = true;
      port = cfg.cache.redisPort;
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.server.port ];
    };
  };
}
