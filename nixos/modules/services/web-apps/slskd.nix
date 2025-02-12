{
  lib,
  pkgs,
  config,
  ...
}:

let
  settingsFormat = pkgs.formats.yaml { };
  defaultUser = "slskd";
in
{
  options.services.slskd =
    with lib;
    with types;
    {
      enable = mkEnableOption "slskd";

      package = mkPackageOption pkgs "slskd" { };

      user = mkOption {
        type = types.str;
        default = defaultUser;
        description = "User account under which slskd runs.";
      };

      group = mkOption {
        type = types.str;
        default = defaultUser;
        description = "Group under which slskd runs.";
      };

      domain = mkOption {
        type = types.nullOr types.str;
        description = ''
          If non-null, enables an nginx reverse proxy virtual host at this FQDN,
          at the path configurated with `services.slskd.web.url_base`.
        '';
        example = "slskd.example.com";
      };

      nginx = mkOption {
        type = types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
        default = { };
        example = lib.literalExpression ''
          {
            enableACME = true;
            forceHttps = true;
          }
        '';
        description = ''
          This option customizes the nginx virtual host set up for slskd.
        '';
      };

      environmentFile = mkOption {
        type = path;
        description = ''
          Path to the environment file sourced on startup.
          It must at least contain the variables `SLSKD_SLSK_USERNAME` and `SLSKD_SLSK_PASSWORD`.
          Web interface credentials should also be set here in `SLSKD_USERNAME` and `SLSKD_PASSWORD`.
          Other, optional credentials like SOCKS5 with `SLSKD_SLSK_PROXY_USERNAME` and `SLSKD_SLSK_PROXY_PASSWORD`
          should all reside here instead of in the world-readable nix store.
          Variables are documented at https://github.com/slskd/slskd/blob/master/docs/config.md
        '';
      };

      openFirewall = mkOption {
        type = bool;
        description = "Whether to open the firewall for the soulseek network listen port (not the web interface port).";
        default = false;
      };

      settings = mkOption {
        description = ''
          Application configuration for slskd. See
          [documentation](https://github.com/slskd/slskd/blob/master/docs/config.md).
        '';
        default = { };
        type = submodule {
          freeformType = settingsFormat.type;
          options = {
            remote_file_management = mkEnableOption "modification of share contents through the web ui";

            flags = {
              force_share_scan = mkOption {
                type = bool;
                description = "Force a rescan of shares on every startup.";
              };
              no_version_check = mkOption {
                type = bool;
                default = true;
                visible = false;
                description = "Don't perform a version check on startup.";
              };
            };

            directories = {
              incomplete = mkOption {
                type = nullOr path;
                description = "Directory where incomplete downloading files are stored.";
                defaultText = "/var/lib/slskd/incomplete";
                default = null;
              };
              downloads = mkOption {
                type = nullOr path;
                description = "Directory where downloaded files are stored.";
                defaultText = "/var/lib/slskd/downloads";
                default = null;
              };
            };

            shares = {
              directories = mkOption {
                type = listOf str;
                description = ''
                  Paths to shared directories. See
                  [documentation](https://github.com/slskd/slskd/blob/master/docs/config.md#directories)
                  for advanced usage.
                '';
                example = lib.literalExpression ''[ "/home/John/Music" "!/home/John/Music/Recordings" "[Music Drive]/mnt" ]'';
              };
              filters = mkOption {
                type = listOf str;
                example = lib.literalExpression ''[ "\.ini$" "Thumbs.db$" "\.DS_Store$" ]'';
                description = "Regular expressions of files to exclude from sharing.";
              };
            };

            rooms = mkOption {
              type = listOf str;
              description = "Chat rooms to join on startup.";
            };

            soulseek = {
              description = mkOption {
                type = str;
                description = "The user description for the Soulseek network.";
                defaultText = "A slskd user. https://github.com/slskd/slskd";
              };
              listen_port = mkOption {
                type = port;
                description = "The port on which to listen for incoming connections.";
                default = 50300;
              };
            };

            global = {
              # TODO speed units
              upload = {
                slots = mkOption {
                  type = ints.unsigned;
                  description = "Limit of the number of concurrent upload slots.";
                };
                speed_limit = mkOption {
                  type = ints.unsigned;
                  description = "Total upload speed limit.";
                };
              };
              download = {
                slots = mkOption {
                  type = ints.unsigned;
                  description = "Limit of the number of concurrent download slots.";
                };
                speed_limit = mkOption {
                  type = ints.unsigned;
                  description = "Total upload download limit";
                };
              };
            };

            filters.search.request = mkOption {
              type = listOf str;
              example = lib.literalExpression ''[ "^.{1,2}$" ]'';
              description = "Incoming search requests which match this filter are ignored.";
            };

            web = {
              port = mkOption {
                type = port;
                default = 5030;
                description = "The HTTP listen port.";
              };
              url_base = mkOption {
                type = path;
                default = "/";
                description = "The base path in the url for web requests.";
              };
              # Users should use a reverse proxy instead for https
              https.disabled = mkOption {
                type = bool;
                default = true;
                description = "Disable the built-in HTTPS server";
              };
            };

            retention = {
              transfers = {
                upload = {
                  succeeded = mkOption {
                    type = ints.unsigned;
                    description = "Lifespan of succeeded upload tasks.";
                    defaultText = "(indefinite)";
                  };
                  errored = mkOption {
                    type = ints.unsigned;
                    description = "Lifespan of errored upload tasks.";
                    defaultText = "(indefinite)";
                  };
                  cancelled = mkOption {
                    type = ints.unsigned;
                    description = "Lifespan of cancelled upload tasks.";
                    defaultText = "(indefinite)";
                  };
                };
                download = {
                  succeeded = mkOption {
                    type = ints.unsigned;
                    description = "Lifespan of succeeded download tasks.";
                    defaultText = "(indefinite)";
                  };
                  errored = mkOption {
                    type = ints.unsigned;
                    description = "Lifespan of errored download tasks.";
                    defaultText = "(indefinite)";
                  };
                  cancelled = mkOption {
                    type = ints.unsigned;
                    description = "Lifespan of cancelled download tasks.";
                    defaultText = "(indefinite)";
                  };
                };
              };
              files = {
                complete = mkOption {
                  type = ints.unsigned;
                  description = "Lifespan of completely downloaded files in minutes.";
                  example = 20160;
                  defaultText = "(indefinite)";
                };
                incomplete = mkOption {
                  type = ints.unsigned;
                  description = "Lifespan of incomplete downloading files in minutes.";
                  defaultText = "(indefinite)";
                };
              };
            };

            logger = {
              # Disable by default, journald already retains as needed
              disk = mkOption {
                type = bool;
                description = "Whether to log to the application directory.";
                default = false;
                visible = false;
              };
            };
          };
        };
      };
    };

  config =
    let
      cfg = config.services.slskd;

      confWithoutNullValues = (
        lib.filterAttrsRecursive (
          key: value: (builtins.tryEval value).success && value != null
        ) cfg.settings
      );

      configurationYaml = settingsFormat.generate "slskd.yml" confWithoutNullValues;

    in
    lib.mkIf cfg.enable {

      # Force off, configuration file is in nix store and is immutable
      services.slskd.settings.remote_configuration = lib.mkForce false;

      users.users = lib.optionalAttrs (cfg.user == defaultUser) {
        "${defaultUser}" = {
          group = cfg.group;
          isSystemUser = true;
        };
      };

      users.groups = lib.optionalAttrs (cfg.group == defaultUser) {
        "${defaultUser}" = { };
      };

      systemd.services.slskd = {
        description = "A modern client-server application for the Soulseek file sharing network";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          StateDirectory = "slskd"; # Creates /var/lib/slskd and manages permissions
          ExecStart = "${cfg.package}/bin/slskd --app-dir /var/lib/slskd --config ${configurationYaml}";
          Restart = "on-failure";
          ReadOnlyPaths = map (
            d: builtins.elemAt (builtins.split "[^/]*(/.+)" d) 1
          ) cfg.settings.shares.directories;
          ReadWritePaths =
            (lib.optional (cfg.settings.directories.incomplete != null) cfg.settings.directories.incomplete)
            ++ (lib.optional (cfg.settings.directories.downloads != null) cfg.settings.directories.downloads);
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateMounts = true;
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
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictNamespaces = true;
          RestrictSUIDSGID = true;
        };
      };

      networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.settings.soulseek.listen_port;

      services.nginx = lib.mkIf (cfg.domain != null) {
        enable = lib.mkDefault true;
        virtualHosts."${cfg.domain}" = lib.mkMerge [
          cfg.nginx
          {
            locations."${cfg.settings.web.url_base}" = {
              proxyPass = "http://127.0.0.1:${toString cfg.settings.web.port}";
              proxyWebsockets = true;
            };
          }
        ];
      };
    };

  meta = {
    maintainers = with lib.maintainers; [
      ppom
      melvyn2
    ];
  };
}
