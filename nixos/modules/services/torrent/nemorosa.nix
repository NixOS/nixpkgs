{
  config,
  lib,
  pkgs,
  utils,
  maintainers,
  ...
}:
let
  cfg = config.services.nemorosa;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;
  inherit (lib.types)
    port
    str
    submodule
    ;

  settingsFormat = pkgs.formats.yaml { };
  stateDir = "/var/lib/nemorosa";
  configPath = "${stateDir}/config.yaml";
  # YAML is a JSON superset
  secretsReplacement = utils.genJqSecretsReplacement {
    loadCredential = true;
  } cfg.settings configPath;
in
{
  options.services.nemorosa = {
    enable = mkEnableOption "nemorosa";

    package = mkPackageOption pkgs "nemorosa" { };

    user = mkOption {
      type = str;
      default = "nemorosa";
      description = "User to run nemorosa as.";
    };

    group = mkOption {
      type = str;
      default = "nemorosa";
      description = "Group to run nemorosa as.";
    };

    settings = mkOption {
      description = ''
        Configuration options for nemorosa.
        See [the nemorosa documentation](https://github.com/KyokoMiki/nemorosa/wiki/Configuration)
        for all configuration options.

        The configuration is processed using [utils.genJqSecretsReplacement](https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/utils.nix#L232-L331) to handle secret substitution.
        Use this for sensitive configuration options.
      '';
      default = { };
      example = {
        linking = {
          enable_linking = true;
          link_dirs = [ "/mnt/some/folder" ];
        };
        downloader = {
          client = {
            _secret = "/run/secrets/torrent-client-url";
          };
        };
        target_site = [
          {
            server = "https://someurl.com";
            api_key = {
              _secret = "/run/secrets/someurl_api-key";
            };
          }
        ];
      };
      type = submodule {
        freeformType = settingsFormat.type;
        options = {
          server = mkOption {
            default = { };
            description = "Web server configuration";
            type = submodule {
              freeformType = settingsFormat.type;
              options = {
                host = mkOption {
                  type = str;
                  default = "127.0.0.1";
                  description = "Host address the nemorosa daemon listens on.";
                };
                port = mkOption {
                  type = port;
                  default = 8256;
                  description = "Port the nemorosa daemon listens on.";
                };
              };
            };
          };
        };
      };
    };
  };

  config = mkIf (cfg.enable) {
    systemd = {
      services.nemorosa = {
        description = "nemorosa";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        preStart = secretsReplacement.script;

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          # On partial matches the torrent client also needs to write to the
          # link_dirs. With default 755/644 permissions this is not possible,
          # unless the user is the same as the torrent client user.
          UMask = mkIf (cfg.user == "nemorosa") "0002";
          StateDirectory = "nemorosa";
          LoadCredential = secretsReplacement.credentials;

          ExecStart = "${getExe cfg.package} --server --config ${configPath}";

          SocketBindDeny = "any";
          SocketBindAllow = cfg.settings.server.port;

          # Based the qbittorrent hardening settings
          CapabilityBoundingSet = "";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateNetwork = false;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = "yes";
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "full";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" ];
        };
      };
    };

    users = {
      users = mkIf (cfg.user == "nemorosa") {
        nemorosa = {
          group = cfg.group;
          description = "nemorosa user";
          isSystemUser = true;
          home = stateDir;
        };
      };

      groups = mkIf (cfg.group == "nemorosa") {
        nemorosa = { };
      };
    };
  };

  meta.maintainers = with maintainers; [ undefined-landmark ];
}
