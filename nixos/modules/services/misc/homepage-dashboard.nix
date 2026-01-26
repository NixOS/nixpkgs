{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.homepage-dashboard;
  # Define the settings format used for this program
  settingsFormat = pkgs.formats.yaml { };
in
{
  options = {
    services.homepage-dashboard = {
      enable = lib.mkEnableOption "Homepage Dashboard, a highly customizable application dashboard";

      package = lib.mkPackageOption pkgs "homepage-dashboard" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for Homepage.";
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 8082;
        description = "Port for Homepage to bind to.";
      };

      allowedHosts = lib.mkOption {
        type = lib.types.str;
        default = "localhost:8082,127.0.0.1:8082";
        example = "example.com";
        description = ''
          Hosts that homepage-dashboard will be running under.
          You will want to change this in order to acess homepage from anything other than localhost.
          see the upsream documentation:

          <https://gethomepage.dev/installation/#homepage_allowed_hosts>
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.str;
        description = ''
          The path to an environment file that contains environment variables to pass
          to the homepage-dashboard service, for the purpose of passing secrets to
          the service.

          See the upstream documentation:

          <https://gethomepage.dev/installation/docker/#using-environment-secrets>
        '';
        default = "";
      };

      customCSS = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Custom CSS for styling Homepage.

          See <https://gethomepage.dev/configs/custom-css-js/>.
        '';
        default = "";
      };

      customJS = lib.mkOption {
        type = lib.types.lines;
        description = ''
          Custom Javascript for Homepage.

          See <https://gethomepage.dev/configs/custom-css-js/>.
        '';
        default = "";
      };

      bookmarks = lib.mkOption {
        inherit (settingsFormat) type;
        description = ''
          Homepage bookmarks configuration.

          See <https://gethomepage.dev/configs/bookmarks/>.
        '';
        # Defaults: https://github.com/gethomepage/homepage/blob/main/src/skeleton/bookmarks.yaml
        example = [
          {
            Developer = [
              {
                Github = [
                  {
                    abbr = "GH";
                    href = "https://github.com/";
                  }
                ];
              }
            ];
          }
          {
            Entertainment = [
              {
                YouTube = [
                  {
                    abbr = "YT";
                    href = "https://youtube.com/";
                  }
                ];
              }
            ];
          }
        ];
        default = [ ];
      };

      services = lib.mkOption {
        inherit (settingsFormat) type;
        description = ''
          Homepage services configuration.

          See <https://gethomepage.dev/configs/services/>.
        '';
        # Defaults: https://github.com/gethomepage/homepage/blob/main/src/skeleton/services.yaml
        example = [
          {
            "My First Group" = [
              {
                "My First Service" = {
                  href = "http://localhost/";
                  description = "Homepage is awesome";
                };
              }
            ];
          }
          {
            "My Second Group" = [
              {
                "My Second Service" = {
                  href = "http://localhost/";
                  description = "Homepage is the best";
                };
              }
            ];
          }
        ];
        default = [ ];
      };

      widgets = lib.mkOption {
        inherit (settingsFormat) type;
        description = ''
          Homepage widgets configuration.

          See <https://gethomepage.dev/widgets/>.
        '';
        # Defaults: https://github.com/gethomepage/homepage/blob/main/src/skeleton/widgets.yaml
        example = [
          {
            resources = {
              cpu = true;
              memory = true;
              disk = "/";
            };
          }
          {
            search = {
              provider = "duckduckgo";
              target = "_blank";
            };
          }
        ];
        default = [ ];
      };

      kubernetes = lib.mkOption {
        inherit (settingsFormat) type;
        description = ''
          Homepage kubernetes configuration.

          See <https://gethomepage.dev/configs/kubernetes/>.
        '';
        default = { };
      };

      docker = lib.mkOption {
        inherit (settingsFormat) type;
        description = ''
          Homepage docker configuration.

          See <https://gethomepage.dev/configs/docker/>.
        '';
        default = { };
      };

      proxmox = lib.mkOption {
        inherit (settingsFormat) type;
        description = ''
          Homepage proxmox configuration.

          See <https://gethomepage.dev/configs/proxmox/>.
        '';
        default = { };
      };

      settings = lib.mkOption {
        inherit (settingsFormat) type;
        description = ''
          Homepage settings.

          See <https://gethomepage.dev/configs/settings/>.
        '';
        # Defaults: https://github.com/gethomepage/homepage/blob/main/src/skeleton/settings.yaml
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc = {
      "homepage-dashboard/custom.css".text = cfg.customCSS;
      "homepage-dashboard/custom.js".text = cfg.customJS;
      "homepage-dashboard/bookmarks.yaml".source = settingsFormat.generate "bookmarks.yaml" cfg.bookmarks;
      "homepage-dashboard/docker.yaml".source = settingsFormat.generate "docker.yaml" cfg.docker;
      "homepage-dashboard/kubernetes.yaml".source =
        settingsFormat.generate "kubernetes.yaml" cfg.kubernetes;
      "homepage-dashboard/services.yaml".source = settingsFormat.generate "services.yaml" cfg.services;
      "homepage-dashboard/settings.yaml".source = settingsFormat.generate "settings.yaml" cfg.settings;
      "homepage-dashboard/widgets.yaml".source = settingsFormat.generate "widgets.yaml" cfg.widgets;
      "homepage-dashboard/proxmox.yaml".source = settingsFormat.generate "proxmox.yaml" cfg.proxmox;
    };

    systemd.services.homepage-dashboard = {
      description = "Homepage Dashboard";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOMEPAGE_CONFIG_DIR = "/etc/homepage-dashboard";
        NIXPKGS_HOMEPAGE_CACHE_DIR = "/var/cache/homepage-dashboard";
        PORT = toString cfg.listenPort;
        LOG_TARGETS = "stdout";
        HOMEPAGE_ALLOWED_HOSTS = cfg.allowedHosts;
      };

      serviceConfig =
        let
          servicePort = cfg.listenPort < 1024;
        in
        {
          Type = "simple";
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          StateDirectory = "homepage-dashboard";
          CacheDirectory = "homepage-dashboard";
          ExecStart = lib.getExe cfg.package;
          Restart = "on-failure";

          # hardening
          DynamicUser = true;
          DevicePolicy = "closed";
          CapabilityBoundingSet = "" + (lib.optionalString servicePort) "CAP_NET_BIND_SERVICE";
          AmbientCapabilities = lib.optionals servicePort [ "CAP_NET_BIND_SERVICE" ];
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
            "AF_NETLINK"
          ];
          DeviceAllow = "";
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateUsers = !servicePort;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          LockPersonality = true;
          RemoveIPC = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@resources"
          ];
          ProtectProc = "invisible";
          ProtectHostname = true;
          UMask = "0077";
          # cpu widget requires access to /proc
          ProcSubset = if lib.any (widget: widget.resources.cpu or false) cfg.widgets then "all" else "pid";
        };

      enableStrictShellChecks = true;

      # Related:
      # * https://github.com/NixOS/nixpkgs/issues/346016 ("homepage-dashboard: cache dir is not cleared upon version upgrade")
      # * https://github.com/gethomepage/homepage/discussions/4560 ("homepage NixOS package does not clear cache on upgrade leaving broken state")
      # * https://github.com/vercel/next.js/discussions/58864 ("Feature Request: Allow configuration of cache dir")
      preStart = ''
        rm -rf "''${NIXPKGS_HOMEPAGE_CACHE_DIR:?}"/*
      '';
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listenPort ];
    };
  };
}
