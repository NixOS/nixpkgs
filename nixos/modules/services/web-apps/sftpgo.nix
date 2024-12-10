{
  options,
  config,
  lib,
  pkgs,
  utils,
  ...
}:

with lib;

let
  cfg = config.services.sftpgo;
  defaultUser = "sftpgo";
  settingsFormat = pkgs.formats.json { };
  configFile = settingsFormat.generate "sftpgo.json" cfg.settings;
  hasPrivilegedPorts = any (port: port > 0 && port < 1024) (
    catAttrs "port" (
      cfg.settings.httpd.bindings
      ++ cfg.settings.ftpd.bindings
      ++ cfg.settings.sftpd.bindings
      ++ cfg.settings.webdavd.bindings
    )
  );
in
{
  options.services.sftpgo = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "sftpgo";
    };

    package = mkPackageOption pkgs "sftpgo" { };

    extraArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        Additional command line arguments to pass to the sftpgo daemon.
      '';
      example = [
        "--log-level"
        "info"
      ];
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/sftpgo";
      description = ''
        The directory where SFTPGo stores its data files.
      '';
    };

    extraReadWriteDirs = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        Extra directories where SFTPGo is allowed to write to.
      '';
    };

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = ''
        User account name under which SFTPGo runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = defaultUser;
      description = ''
        Group name under which SFTPGo runs.
      '';
    };

    loadDataFile = mkOption {
      default = null;
      type = with types; nullOr path;
      description = ''
        Path to a json file containing users and folders to load (or update) on startup.
        Check the [documentation](https://sftpgo.github.io/latest/config-file/)
        for the `--loaddata-from` command line argument for more info.
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        The primary sftpgo configuration. See the
        [configuration reference](https://sftpgo.github.io/latest/config-file/)
        for possible values.
      '';
      type =
        with types;
        submodule {
          freeformType = settingsFormat.type;
          options = {
            httpd.bindings = mkOption {
              default = [ ];
              description = ''
                Configure listen addresses and ports for httpd.
              '';
              type = types.listOf (
                types.submodule {
                  freeformType = settingsFormat.type;
                  options = {
                    address = mkOption {
                      type = types.str;
                      default = "127.0.0.1";
                      description = ''
                        Network listen address. Leave blank to listen on all available network interfaces.
                        On *NIX you can specify an absolute path to listen on a Unix-domain socket.
                      '';
                    };

                    port = mkOption {
                      type = types.port;
                      default = 8080;
                      description = ''
                        The port for serving HTTP(S) requests.

                        Setting the port to `0` disables listening on this interface binding.
                      '';
                    };

                    enable_web_admin = mkOption {
                      type = types.bool;
                      default = true;
                      description = ''
                        Enable the built-in web admin for this interface binding.
                      '';
                    };

                    enable_web_client = mkOption {
                      type = types.bool;
                      default = true;
                      description = ''
                        Enable the built-in web client for this interface binding.
                      '';
                    };
                  };
                }
              );
            };

            ftpd.bindings = mkOption {
              default = [ ];
              description = ''
                Configure listen addresses and ports for ftpd.
              '';
              type = types.listOf (
                types.submodule {
                  freeformType = settingsFormat.type;
                  options = {
                    address = mkOption {
                      type = types.str;
                      default = "127.0.0.1";
                      description = ''
                        Network listen address. Leave blank to listen on all available network interfaces.
                        On *NIX you can specify an absolute path to listen on a Unix-domain socket.
                      '';
                    };

                    port = mkOption {
                      type = types.port;
                      default = 0;
                      description = ''
                        The port for serving FTP requests.

                        Setting the port to `0` disables listening on this interface binding.
                      '';
                    };
                  };
                }
              );
            };

            sftpd.bindings = mkOption {
              default = [ ];
              description = ''
                Configure listen addresses and ports for sftpd.
              '';
              type = types.listOf (
                types.submodule {
                  freeformType = settingsFormat.type;
                  options = {
                    address = mkOption {
                      type = types.str;
                      default = "127.0.0.1";
                      description = ''
                        Network listen address. Leave blank to listen on all available network interfaces.
                        On *NIX you can specify an absolute path to listen on a Unix-domain socket.
                      '';
                    };

                    port = mkOption {
                      type = types.port;
                      default = 0;
                      description = ''
                        The port for serving SFTP requests.

                        Setting the port to `0` disables listening on this interface binding.
                      '';
                    };
                  };
                }
              );
            };

            webdavd.bindings = mkOption {
              default = [ ];
              description = ''
                Configure listen addresses and ports for webdavd.
              '';
              type = types.listOf (
                types.submodule {
                  freeformType = settingsFormat.type;
                  options = {
                    address = mkOption {
                      type = types.str;
                      default = "127.0.0.1";
                      description = ''
                        Network listen address. Leave blank to listen on all available network interfaces.
                        On *NIX you can specify an absolute path to listen on a Unix-domain socket.
                      '';
                    };

                    port = mkOption {
                      type = types.port;
                      default = 0;
                      description = ''
                        The port for serving WebDAV requests.

                        Setting the port to `0` disables listening on this interface binding.
                      '';
                    };
                  };
                }
              );
            };

            smtp = mkOption {
              default = { };
              description = ''
                SMTP configuration section.
              '';
              type = types.submodule {
                freeformType = settingsFormat.type;
                options = {
                  host = mkOption {
                    type = types.str;
                    default = "";
                    description = ''
                      Location of SMTP email server. Leave empty to disable email sending capabilities.
                    '';
                  };

                  port = mkOption {
                    type = types.port;
                    default = 465;
                    description = "Port of the SMTP Server.";
                  };

                  encryption = mkOption {
                    type = types.enum [
                      0
                      1
                      2
                    ];
                    default = 1;
                    description = ''
                      Encryption scheme:
                      - `0`: No encryption
                      - `1`: TLS
                      - `2`: STARTTLS
                    '';
                  };

                  auth_type = mkOption {
                    type = types.enum [
                      0
                      1
                      2
                    ];
                    default = 0;
                    description = ''
                      - `0`: Plain
                      - `1`: Login
                      - `2`: CRAM-MD5
                    '';
                  };

                  user = mkOption {
                    type = types.str;
                    default = "sftpgo";
                    description = "SMTP username.";
                  };

                  from = mkOption {
                    type = types.str;
                    default = "SFTPGo <sftpgo@example.com>";
                    description = ''
                      From address.
                    '';
                  };
                };
              };
            };
          };
        };
    };
  };

  config = mkIf cfg.enable {
    services.sftpgo.settings = (
      mapAttrs (name: mkDefault) {
        ftpd.bindings = [ { port = 0; } ];
        httpd.bindings = [ { port = 0; } ];
        sftpd.bindings = [ { port = 0; } ];
        webdavd.bindings = [ { port = 0; } ];
        httpd.openapi_path = "${cfg.package}/share/sftpgo/openapi";
        httpd.templates_path = "${cfg.package}/share/sftpgo/templates";
        httpd.static_files_path = "${cfg.package}/share/sftpgo/static";
        smtp.templates_path = "${cfg.package}/share/sftpgo/templates";
      }
    );

    users = optionalAttrs (cfg.user == defaultUser) {
      users = {
        ${defaultUser} = {
          description = "SFTPGo system user";
          isSystemUser = true;
          group = defaultUser;
          home = cfg.dataDir;
        };
      };

      groups = {
        ${defaultUser} = {
          members = [ defaultUser ];
        };
      };
    };

    systemd.services.sftpgo = {
      description = "SFTPGo daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        SFTPGO_CONFIG_FILE = mkDefault configFile;
        SFTPGO_LOG_FILE_PATH = mkDefault ""; # log to journal
        SFTPGO_LOADDATA_FROM = mkIf (cfg.loadDataFile != null) cfg.loadDataFile;
      };

      serviceConfig = mkMerge [
        ({
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.dataDir;
          ReadWritePaths = [ cfg.dataDir ] ++ cfg.extraReadWriteDirs;
          LimitNOFILE = 8192; # taken from upstream
          KillMode = "mixed";
          ExecStart = "${cfg.package}/bin/sftpgo serve ${utils.escapeSystemdExecArgs cfg.extraArgs}";
          ExecReload = "${pkgs.util-linux}/bin/kill -s HUP $MAINPID";

          # Service hardening
          CapabilityBoundingSet = [ (optionalString hasPrivilegedPorts "CAP_NET_BIND_SERVICE") ];
          DevicePolicy = "closed";
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProcSubset = "pid";
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
          RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          UMask = "0077";
        })
        (mkIf hasPrivilegedPorts {
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        })
        (mkIf (cfg.dataDir == options.services.sftpgo.dataDir.default) {
          StateDirectory = baseNameOf cfg.dataDir;
        })
      ];
    };
  };
}
