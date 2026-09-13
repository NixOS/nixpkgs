{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.pelican-wings;
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    mkDefault
    optionalAttrs
    recursiveUpdate
    maintainers
    getExe
    ;
in
{
  options.services.pelican-wings = {
    enable = mkEnableOption "Pelican Wings daemon";
    enableTraefik = mkEnableOption "Traefik reverse proxy configuration for Wings";

    package = mkPackageOption pkgs "pelican-wings" { };

    openFirewall = mkEnableOption "firewall rules for Wings. Will open both the SFTP port 2022 and the apiPort. Disable if you're using a reverse proxy and open 2022 manually.";
    domain = mkOption {
      type = types.str;
      description = "the domain to run Wings on. Must be reachable from the panel and from all clients accessing the panel";
    };

    configuration = mkOption {
      type = types.attrs;
      default = { };
      description = "Base Wings configuration written to the Nix store at eval time. Merged with secretConfigurationFile at runtime, with secrets taking precedence.";
    };

    secretConfigurationFile = mkOption {
      type = types.path;
      description = "Path to a YAML file containing secret configuration values. Merged on top of configuration at runtime.";
    };

    apiPort = mkOption {
      type = types.port;
      default = 8080;
      description = "Port Wings listens on.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = mkDefault true;

    systemd.services.wings =
      let
        autoConfig =
          recursiveUpdate
            {
              system.sftp.bind_port = 2022;
              api.port = cfg.apiPort;
            }
            (
              optionalAttrs cfg.enableTraefik {
                api = {
                  host = "0.0.0.0";
                  ssl.enabled = false;
                };
              }
            );
        storeConfig = (pkgs.formats.yaml { }).generate "wings-config.yml" (
          recursiveUpdate autoConfig cfg.configuration
        );
      in
      {
        description = "Pelican Wings Daemon";
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        wantedBy = [ "multi-user.target" ];

        path = with pkgs; [
          shadow
          yq-go
        ];

        serviceConfig = {
          User = "root";
          LimitNOFILE = 4096;
          ExecStartPre = pkgs.writeShellScript "wings-pre" ''
            yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
              ${storeConfig} ${cfg.secretConfigurationFile} > /etc/pelican/config.yml
          '';
          ExecStart = "${getExe cfg.package} --config /etc/pelican/config.yml";
          Restart = "on-failure";
          RestartSec = "5s";
        };

        unitConfig = {
          StartLimitIntervalSec = 180;
          StartLimitBurst = 30;
        };
      };

    services.traefik.dynamicConfigOptions = mkIf cfg.enableTraefik {
      http = {
        routers.wings = {
          entryPoints = [ "websecure" ];
          rule = "Host(`${cfg.domain}`)";
          service = "wings";
          tls.certResolver = "letsencrypt";
        };

        services.wings.loadBalancer = {
          passHostHeader = true;
          servers = [ { url = "http://127.0.0.1:${toString cfg.apiPort}"; } ];
        };
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        2022
        cfg.apiPort
      ];
    };
  };

  meta = {
    maintainers = with maintainers; [
      oskardotglobal
      nullcube
    ];
    doc = ./pelican-wings.md;
  };
}
