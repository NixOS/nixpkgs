{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.filebrowser-quantum;
  jsonFormat = pkgs.formats.json { };
in
{
  options.services.filebrowser-quantum = {
    enable = lib.mkEnableOption "Filebrowser-quantum web file manager";

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address to bind to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 80;
      description = "Port to bind to.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.filebrowser-quantum;
      description = "The filebrowser-quantum package to use.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "filebrowser-quantum";
      description = "User account under which filebrowser-quantum runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "filebrowser-quantum";
      description = "Group under which filebrowser-quantum runs.";
    };

    home = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/filebrowser-quantum";
      description = "The home of the filebrowser-quantum user";
    };

    files = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.home}/files";
      description = "Root directory for file browsing.";
    };

    database = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.home}/database.db";
      description = "Path to the database file.";
    };

    environmentVariables = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = "Environment variables to set for the service. All availble variables can be found [here](https://github.com/gtsteffaniak/filebrowser/wiki/Environment-Variables)";
    };
    environmentFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "Environment file to set for the service. All availble variables can be found [here](https://github.com/gtsteffaniak/filebrowser/wiki/Environment-Variables)";
    };

    settings = lib.mkOption {
      type = jsonFormat.type;
      default = {
        server = {
          port = cfg.port;
          database = cfg.database;
          sources = [
            {
              path = cfg.files;
            }
          ];
          logging = [
            {
              levels = "info|warning|error";
              apiLevels = "info|warning|error";
              output = "stdout";
              noColors = false;
              utc = false;
            }
          ];
        };
        frontend.name = "Filebrowser Quantum";
        auth = {
          adminUsername = "admin";
          adminPassword = "admin";
        };
        userDefaults.permissions = {
          api = false;
          admin = false;
          modify = false;
          share = false;
          realtime = false;
        };
      };
      description = # markdown
        ''
          Configuration settings for filebrowser.
          The defaults are the default settings generated using `Filebrowser setup` All configuration settings with explaination can be found [here](https://github.com/gtsteffaniak/filebrowser/wiki/Full-Config-Example).
          If settings = { } then the config.yaml in the home directory will be used.
        '';
      example = # nix
        ''
          {
            server = {
              numImageProcessors = 14;
              socket = "";
              tlsKey = "";
              tlsCert = "";
              disablePreviews = false;
              disablePreviewResize = false;
              disableTypeDetectionByHeader = false;
              port = 80;
              baseURL = "/";
              logging = [
                {
                  levels = "";
                  apiLevels = "";
                  output = "stdout";
                  noColors = false;
                  json = false;
                  utc = false;
                }
              ];
              debugMedia = false;
              database = "database.db";
              sources = [
                {
                  path = "/relative/or/absolute/path";
                  name = "backend";
                  config = {
                    indexingIntervalMinutes = 0;
                    disableIndexing = false;
                    maxWatchers = 0;
                    neverWatchPaths = [

                    ];
                    ignoreHidden = false;
                    ignoreZeroSizeFolders = false;
                    exclude = {
                      files = [

                      ];
                      folders = [

                      ];
                      fileEndsWith = [

                      ];
                    };
                    include = {
                      files = [

                      ];
                      folders = [

                      ];
                      fileEndsWith = [

                      ];
                    };
                    defaultUserScope = "/";
                    defaultEnabled = true;
                    createUserDir = false;
                  };
                }
              ];
              externalUrl = "";
              internalUrl = "";
              cacheDir = "tmp";
              maxArchiveSize = 50;
            };
            auth = {
              tokenExpirationHours = 2;
              methods = {
                proxy = {
                  enabled = false;
                  createUser = false;
                  header = "";
                  logoutRedirectUrl = "";
                };
                noauth = false;
                password = {
                  enabled = true;
                  minLength = 5;
                  signup = false;
                  recaptcha = {
                    host = "";
                    key = "";
                    secret = "";
                  };
                  enforcedOtp = false;
                };
                oidc = {
                  enabled = false;
                  clientId = "";
                  clientSecret = "";
                  issuerUrl = "";
                  scopes = "";
                  userIdentifier = "";
                  disableVerifyTLS = false;
                  logoutRedirectUrl = "";
                  createUser = false;
                  adminGroup = "";
                };
              };
              key = "";
              adminUsername = "admin";
              adminPassword = "admin";
              resetAdminOnStart = false;
              totpSecret = "";
            };
            frontend = {
              name = "FileBrowser Quantum";
              disableDefaultLinks = false;
              disableUsedPercentage = false;
              externalLinks = [
                {
                  text = "(untracked)";
                  title = "untracked";
                  url = "https://github.com/gtsteffaniak/filebrowser/releases/";
                }
                {
                  text = "Help";
                  title = "";
                  url = "https://github.com/gtsteffaniak/filebrowser/wiki";
                }
              ];
            };
            userDefaults = {
              stickySidebar = true;
              darkMode = true;
              locale = "en";
              viewMode = "normal";
              singleClick = false;
              showHidden = false;
              dateFormat = false;
              gallerySize = 3;
              themeColor = "var(--blue)";
              quickDownload = false;
              disableOnlyOfficeExt = ".txt .csv .html .pdf";
              disableOfficePreviewExt = "";
              lockPassword = false;
              disableSettings = false;
              preview = {
                highQuality = false;
                image = false;
                video = false;
                motionVideoPreview = false;
                office = false;
                popup = false;
              };
              permissions = {
                api = false;
                admin = false;
                modify = false;
                share = false;
                realtime = false;
              };
              loginMethod = "password";
              disableUpdateNotifications = false;
            };
            integrations = {
              office = {
                url = "";
                internalUrl = "";
                secret = "";
              };
              media = {
                ffmpegPath = "";
              };
            };
          }
        '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the specified port.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      description = "Filebrowser-quantum service user";
      isSystemUser = true;
      group = cfg.group;
      home = cfg.home;
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    systemd.services.filebrowser-quantum = {
      description = "Filebrowser-quantum web file manager";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = cfg.environmentVariables;

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.home;

        EnvironmentFile = cfg.environmentFile;

        ExecStart =
          let
            config =
              if (cfg.settings == { }) then
                "${cfg.home}/config.yaml"
              else
                pkgs.writers.writeJSON "filebrowswer-quantum-config.yaml" cfg.settings;
          in
          "${lib.getExe cfg.package} -c ${config}";

        Restart = "always";
        RestartSec = "10s";

        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = "disconnected";
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.files} 0755 ${cfg.user} ${cfg.group} -"
      "d ${dirOf cfg.database} 0755 ${cfg.user} ${cfg.group} -"
    ];
  };
}
