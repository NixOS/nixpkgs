{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nitter;
  configFile = pkgs.writeText "nitter.conf" ''
    ${generators.toINI {
      # String values need to be quoted
      mkKeyValue = generators.mkKeyValueDefault {
        mkValueString = v:
          if isString v then "\"" + (strings.escape ["\""] (toString v)) + "\""
          else generators.mkValueStringDefault {} v;
      } " = ";
    } (lib.recursiveUpdate {
      Server = cfg.server;
      Cache = cfg.cache;
      Config = cfg.config // { hmacKey = "@hmac@"; };
      Preferences = cfg.preferences;
    } cfg.settings)}
  '';
  # `hmac` is a secret used for cryptographic signing of video URLs.
  # Generate it on first launch, then copy configuration and replace
  # `@hmac@` with this value.
  # We are not using sed as it would leak the value in the command line.
  preStart = pkgs.writers.writePython3 "nitter-prestart" {} ''
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
  options = {
    services.nitter = {
      enable = mkEnableOption "If enabled, start Nitter.";

      package = mkOption {
        default = pkgs.nitter;
        type = types.package;
        defaultText = literalExpression "pkgs.nitter";
        description = lib.mdDoc "The nitter derivation to use.";
      };

      server = {
        address = mkOption {
          type =  types.str;
          default = "0.0.0.0";
          example = "127.0.0.1";
          description = lib.mdDoc "The address to listen on.";
        };

        port = mkOption {
          type = types.port;
          default = 8080;
          example = 8000;
          description = lib.mdDoc "The port to listen on.";
        };

        https = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Set secure attribute on cookies. Keep it disabled to enable cookies when not using HTTPS.";
        };

        httpMaxConnections = mkOption {
          type = types.int;
          default = 100;
          description = lib.mdDoc "Maximum number of HTTP connections.";
        };

        staticDir = mkOption {
          type = types.path;
          default = "${cfg.package}/share/nitter/public";
          defaultText = literalExpression ''"''${config.services.nitter.package}/share/nitter/public"'';
          description = lib.mdDoc "Path to the static files directory.";
        };

        title = mkOption {
          type = types.str;
          default = "nitter";
          description = lib.mdDoc "Title of the instance.";
        };

        hostname = mkOption {
          type = types.str;
          default = "localhost";
          example = "nitter.net";
          description = lib.mdDoc "Hostname of the instance.";
        };
      };

      cache = {
        listMinutes = mkOption {
          type = types.int;
          default = 240;
          description = lib.mdDoc "How long to cache list info (not the tweets, so keep it high).";
        };

        rssMinutes = mkOption {
          type = types.int;
          default = 10;
          description = lib.mdDoc "How long to cache RSS queries.";
        };

        redisHost = mkOption {
          type = types.str;
          default = "localhost";
          description = lib.mdDoc "Redis host.";
        };

        redisPort = mkOption {
          type = types.port;
          default = 6379;
          description = lib.mdDoc "Redis port.";
        };

        redisConnections = mkOption {
          type = types.int;
          default = 20;
          description = lib.mdDoc "Redis connection pool size.";
        };

        redisMaxConnections = mkOption {
          type = types.int;
          default = 30;
          description = lib.mdDoc ''
            Maximum number of connections to Redis.

            New connections are opened when none are available, but if the
            pool size goes above this, they are closed when released, do not
            worry about this unless you receive tons of requests per second.
          '';
        };
      };

      config = {
        base64Media = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Use base64 encoding for proxied media URLs.";
        };

        tokenCount = mkOption {
          type = types.int;
          default = 10;
          description = lib.mdDoc ''
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
        replaceTwitter = mkOption {
          type = types.str;
          default = "";
          example = "nitter.net";
          description = lib.mdDoc "Replace Twitter links with links to this instance (blank to disable).";
        };

        replaceYouTube = mkOption {
          type = types.str;
          default = "";
          example = "piped.kavin.rocks";
          description = lib.mdDoc "Replace YouTube links with links to this instance (blank to disable).";
        };

        replaceInstagram = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc "Replace Instagram links with links to this instance (blank to disable).";
        };

        mp4Playback = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Enable MP4 video playback.";
        };

        hlsPlayback = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Enable HLS video streaming (requires JavaScript).";
        };

        proxyVideos = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Proxy video streaming through the server (might be slow).";
        };

        muteVideos = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Mute videos by default.";
        };

        autoplayGifs = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Autoplay GIFs.";
        };

        theme = mkOption {
          type = types.str;
          default = "Nitter";
          description = lib.mdDoc "Instance theme.";
        };

        infiniteScroll = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Infinite scrolling (requires JavaScript, experimental!).";
        };

        stickyProfile = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Make profile sidebar stick to top.";
        };

        bidiSupport = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Support bidirectional text (makes clicking on tweets harder).";
        };

        hideTweetStats = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Hide tweet stats (replies, retweets, likes).";
        };

        hideBanner = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Hide profile banner.";
        };

        hidePins = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Hide pinned tweets.";
        };

        hideReplies = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc "Hide tweet replies.";
        };
      };

      settings = mkOption {
        type = types.attrs;
        default = {};
        description = lib.mdDoc ''
          Add settings here to override NixOS module generated settings.

          Check the official repository for the available settings:
          https://github.com/zedeus/nitter/blob/master/nitter.example.conf
        '';
      };

      redisCreateLocally = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Configure local Redis server for Nitter.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for Nitter web interface.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.redisCreateLocally || (cfg.cache.redisHost == "localhost" && cfg.cache.redisPort == 6379);
        message = "When services.nitter.redisCreateLocally is enabled, you need to use localhost:6379 as a cache server.";
      }
    ];

    systemd.services.nitter = {
        description = "Nitter (An alternative Twitter front-end)";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          DynamicUser = true;
          StateDirectory = "nitter";
          Environment = [ "NITTER_CONF_FILE=/var/lib/nitter/nitter.conf" ];
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
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
          UMask = "0077";
        };
    };

    services.redis.servers.nitter = lib.mkIf (cfg.redisCreateLocally) {
      enable = true;
      port = cfg.cache.redisPort;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.server.port ];
    };
  };
}
