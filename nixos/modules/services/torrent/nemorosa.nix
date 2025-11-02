{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.nemorosa;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;

  settingsFormat = pkgs.formats.yaml { };
  configPath = "${cfg.configDir}/config.json";
in
{
  options.services.nemorosa = {
    enable = mkEnableOption "nemorosa";

    package = mkPackageOption pkgs "nemorosa" { };

    user = mkOption {
      type = types.str;
      default = "nemorosa";
      description = "User to run nemorosa as.";
    };

    group = mkOption {
      type = types.str;
      default = "nemorosa";
      description = "Group to run nemorosa as.";
    };

    configDir = mkOption {
      type = types.path;
      default = "/var/lib/nemorosa";
      description = "Nemorosa config directory";
    };

    settings = mkOption {
      description = ''
        Configuration options for nemorosa.

        Secrets should not be set in this option, as they will be available in
        the Nix store. For secrets, please use settingsFile.

        For more details, see [the cross-seed documentation](https://www.cross-seed.org/docs/basics/options).
      '';
      default = { };
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          linking = mkOption {
            default = { };
            type = types.submodule {
              freeformType = settingsFormat.type;
              options = {
                link_dirs = mkOption {
                  type = types.listOf types.path;
                  default = [ ];
                  description = ''
                    List of directories where nemorosa will create links.

                    If link_type is hardlink, these must be on the same volume as the data.
                  '';
                };
              };
            };
          };

          server = mkOption {
            default = { };
            type = types.submodule {
              freeformType = settingsFormat.type;
              options = {
                host = mkOption {
                  type = types.str;
                  default = "localhost";
                  description = "Host address the nemorosa daemon listens on.";
                };
                port = mkOption {
                  type = types.port;
                  default = 8256;
                  description = "Port the nemorosa daemon listens on.";
                };
              };
            };
          };

          downloader = mkOption {
            default = { };
            type = types.submodule {
              freeformType = settingsFormat.type;
              options = {
                client = mkOption {
                  type = types.str;
                  example = "qbittorrent+http://admin:adminadmin@localhost:8080/";
                  description = ''
                    Torrent client connection URL. See
                    [documentation](https://github.com/KyokoMiki/nemorosa/wiki/Configuration#client)
                    for supported formats.
                  '';
                };
              };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf (cfg.enable) {
    systemd = {
      tmpfiles.settings."10-nemorosa" = {
        ${cfg.configDir}.d = {
          inherit (cfg) group user;
          mode = "700";
        };
      };

      services.nemorosa = {
        description = "nemorosa";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        preStart = utils.genJqSecretsReplacementSnippet cfg.settings configPath;

        serviceConfig = {
          ExecStart = ''
            ${lib.getExe cfg.package} --server --config ${configPath}
          '';
          # DynamicUser so settings like ProtectSystem=strict are used
          DynamicUser = true;
          User = cfg.user;
          Group = cfg.group;

          # Only allow binding to the specified port.
          SocketBindDeny = "any";
          SocketBindAllow = cfg.settings.server.port;

          ReadWritePaths = lib.flatten [
            cfg.settings.linking.link_dirs
            cfg.configDir
          ];
        };
      };
    };

    users = {
      users = lib.mkIf (cfg.user == "nemorosa") {
        nemorosa = {
          group = cfg.group;
          description = "nemorosa user";
          isSystemUser = true;
          home = cfg.configDir;
        };
      };

      groups = lib.mkIf (cfg.group == "nemorosa") {
        nemorosa = { };
      };
    };

    # nemorosa can also be used interactively
    environment.systemPackages = [ cfg.package ];
  };
}
