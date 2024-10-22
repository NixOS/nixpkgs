{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.redlib;

  args = concatStringsSep " " [
    "--port ${toString cfg.port}"
    "--address ${cfg.address}"
  ];

  environment = concatStringsSep " " (
    (mapAttrsToList (k: v: "LIBREDDIT_${toUpper k}=\"${v}\"") cfg.settings)
    ++ (mapAttrsToList (k: v: "LIBREDDIT_DEFAULT_${toUpper k}=\"${v}\"") cfg.defaults)
  );

  boolToFormat = b:
    if b
    then "on"
    else "off";
in {
  imports = [
    (mkRenamedOptionModule ["services" "libreddit"] ["services" "redlib"])
  ];

  options = {
    services.redlib = {
      enable = mkEnableOption "Private front-end for Reddit";

      package = mkPackageOption pkgs "redlib" {};

      address = mkOption {
        default = "0.0.0.0";
        example = "127.0.0.1";
        type = types.str;
        description = "The address to listen on";
      };

      port = mkOption {
        default = 8080;
        example = 8000;
        type = types.port;
        description = "The port to listen on";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the redlib web interface";
      };

      settings = {
        sfw_only = mkOption {
          type = types.bool;
          default = false;
          description = "Enables SFW-only mode for the instance, i.e. all NSFW content is filtered.";
          apply = boolToFormat;
        };
        banner = mkOption {
          type = types.str;
          default = "";
          description = "Allows the server to set a banner to be displayed. Currently this is displayed on the instance info page.";
        };
        robots_disable_indexing = mkOption {
          type = types.bool;
          default = false;
          description = "Disables indexing of the instance by search engines.";
          apply = boolToFormat;
        };
        pushshift_frontend = mkOption {
          type = types.str;
          default = "undelete.pullpush.io";
          example = "www.reveddit.com";
          description = ''Allows the server to set the Pushshift frontend to be used with "removed" links.'';
        };
      };
      defaults = {
        theme = mkOption {
          type = types.enum [
            "system"
            "light"
            "dark"
            "black"
            "dracula"
            "nord"
            "laserwave"
            "violet"
            "gold"
            "rosebox"
            "gruvboxdark"
            "gruvboxlight"
            "tokyoNight"
            "icebergDark"
          ];
          default = "system";
          example = "nord";
          description = "Default site theme";
        };
        front_page = mkOption {
          type = types.enum [
            "default"
            "popular"
            "all"
          ];
          default = "default";
          example = "popular";
          description = "Default front page";
        };
        layout = mkOption {
          type = types.enum [
            "card"
            "clean"
            "compact"
          ];
          default = "card";
          example = "clean";
          description = "Default page layout";
        };
        wide = mkOption {
          type = types.bool;
          default = false;
          description = "Enable wide UI by default";
          apply = boolToFormat;
        };
        post_sort = mkOption {
          type = types.enum [
            "hot"
            "new"
            "top"
            "rising"
            "controversial"
          ];
          default = "hot";
          example = "new";
          description = "Default subreddit post sort";
        };
        comment_sort = mkOption {
          type = types.enum [
            "confidence"
            "top"
            "new"
            "controversial"
            "old"
          ];
          default = "confidence";
          example = "controversial";
          description = "Default comment sort";
        };
        blur_spoiler = mkOption {
          type = types.bool;
          default = false;
          description = "Blur spoiler previews by default";
          apply = boolToFormat;
        };
        show_nsfw = mkOption {
          type = types.bool;
          default = false;
          description = "Show NSFW posts by default";
          apply = boolToFormat;
        };
        blur_nsfw = mkOption {
          type = types.bool;
          default = false;
          description = "Blur NSFW previews by default";
          apply = boolToFormat;
        };
        use_hls = mkOption {
          type = types.bool;
          default = false;
          description = "Use HLS for videos by default";
          apply = boolToFormat;
        };
        hide_hls_notification = mkOption {
          type = types.bool;
          default = false;
          description = "Hide notification about possible HLS usage by default";
          apply = boolToFormat;
        };
        autoplay_videos = mkOption {
          type = types.bool;
          default = false;
          description = "Autoplay videos by default";
          apply = boolToFormat;
        };
        subscriptions = mkOption {
          type = with types; listOf str;
          default = [];
          example = [
            "oddlysatisfying"
            "AskReddit"
          ];
          description = "Subreddits to subcribe to by default";
          apply = subs: concatStringsSep "+" subs;
        };
        hide_awards = mkOption {
          type = types.bool;
          default = false;
          description = "Hide awards by default";
          apply = boolToFormat;
        };
        hide_sidebar_summary = mkOption {
          type = types.bool;
          default = false;
          description = "Hide the summary and sidebar by default";
          apply = boolToFormat;
        };
        hide_score = mkOption {
          type = types.bool;
          default = false;
          description = "Hide score by default";
          apply = boolToFormat;
        };
        disable_visit_reddit_confirmation = mkOption {
          type = types.bool;
          default = false;
          description = "Do not confirm before visiting content on Reddit by default";
          apply = boolToFormat;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.redlib = {
      description = "Private front-end for Reddit";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} ${args}";
        Environment = "${environment}";
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) ["CAP_NET_BIND_SERVICE"];
        Restart = "on-failure";
        RestartSec = "2s";
        # Hardening
        CapabilityBoundingSet =
          if (cfg.port < 1024)
          then ["CAP_NET_BIND_SERVICE"]
          else [""];
        DeviceAllow = [""];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        # A private user cannot have process capabilities on the host's user
        # namespace and thus CAP_NET_BIND_SERVICE has no effect.
        PrivateUsers = cfg.port >= 1024;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = ["@system-service" "~@privileged" "~@resources"];
        UMask = "0077";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [cfg.port];
    };
  };
}
