{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.libreddit;

  args = concatStringsSep " " ([
    "--port ${toString cfg.port}"
    "--address ${cfg.address}"
  ]);

  environment = concatStringsSep " " (
    (mapAttrsToList (k: v: "LIBREDDIT_${toUpper k}=\"${v}\"") cfg.settings) ++
    (mapAttrsToList (k: v: "LIBREDDIT_DEFAULT_${toUpper k}=\"${v}\"") cfg.defaults)
  );

  boolToFormat = b: if b then "on" else "off";
in
{
  options = {
    services.libreddit = {
      enable = mkEnableOption (lib.mdDoc "Private front-end for Reddit");

      package = mkOption {
        type = types.package;
        default = pkgs.libreddit;
        defaultText = literalExpression "pkgs.libreddit";
        description = lib.mdDoc "Libreddit package to use.";
      };

      address = mkOption {
        default = "0.0.0.0";
        example = "127.0.0.1";
        type =  types.str;
        description = lib.mdDoc "The address to listen on";
      };

      port = mkOption {
        default = 8080;
        example = 8000;
        type = types.port;
        description = lib.mdDoc "The port to listen on";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the libreddit web interface";
      };

      settings = {
        sfw_only = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Enables SFW-only mode for the instance, i.e. all NSFW content is filtered.";
        };
        banner = mkOption {
          type = types.str;
          default = "";
          description = lib.mdDoc "Allows the server to set a banner to be displayed. Currently this is displayed on the instance info page.";
        };
        robots_disable_indexing = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Disables indexing of the instance by search engines.";
        };
        pushshift_frontend = mkOption {
          type = types.str;
          default = "www.unddit.com";
          example = "www.reveddit.com";
          description = lib.mdDoc "Allows the server to set the Pushshift frontend to be used with \"removed\" links.";
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
          ];
          default = "system";
          example = "rosebox";
          description = lib.mdDoc "Default site theme";
        };
        front_page = mkOption {
          type = types.enum [
            "default"
            "popular"
            "all"
          ];
          default = "default";
          example = "popular";
          description = lib.mdDoc "Default page";
        };
        layout = mkOption {
          type = types.enum [
            "card"
            "clean"
            "compact"
          ];
          default = "card";
          example = "clean";
          description = lib.mdDoc "Default page layout";
        };
        wide = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Enable wide UI by default";
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
          example = "controversial";
          description = lib.mdDoc "Default subreddit post sort";
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
          description = lib.mdDoc "Default comment sort";
        };
        show_nsfw = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Show NSFW posts by default";
        };
        blur_nsfw = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Blur NSFW previews by default";
        };
        use_hls = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Use HLS for videos by default";
        };
        hide_hls_notification = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Hide notification about possible HLS usage by default";
        };
        autoplay_videos  = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Autoplay videos by default";
        };
        subscriptions = mkOption {
          type = with types; listOf str;
          default = [];
          example = [ "oddlysatisfying" "AskReddit" ];
          apply = subs: concatStringsSep "+" subs;
          description = lib.mdDoc "Subreddits to subcribe to by default";
        };
        hide_awards = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Hide awards by default";
        };
        disable_visit_reddit_confirmation = mkOption {
          type = types.bool;
          default = false;
          apply = boolToFormat;
          description = lib.mdDoc "Do not confirm before visiting content on Reddit by default";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.libreddit = {
        description = "Private front-end for Reddit";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${cfg.package}/bin/libreddit ${args}";
          Environment = "${environment}";
          AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
          Restart = "on-failure";
          RestartSec = "2s";
          # Hardening
          CapabilityBoundingSet = if (cfg.port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
          DeviceAllow = [ "" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          PrivateDevices = true;
          # A private user cannot have process capabilities on the host's user
          # namespace and thus CAP_NET_BIND_SERVICE has no effect.
          PrivateUsers = (cfg.port >= 1024);
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

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
