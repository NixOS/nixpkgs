{ config, lib, pkgs, ... }:

let
  cfg = config.services.trilium-server;
  configIni = pkgs.writeText "trilium-config.ini" ''
    [General]
    # Instance name can be used to distinguish between different instances
    instanceName=${cfg.instanceName}

    # Disable automatically generating desktop icon
    noDesktopIcon=true

    [Network]
    # host setting is relevant only for web deployments - set the host on which the server will listen
    host=${cfg.host}
    # port setting is relevant only for web deployments, desktop builds run on random free port
    port=${toString cfg.port}
    # true for TLS/SSL/HTTPS (secure), false for HTTP (unsecure).
    https=false
  '';
in
{

  options.services.trilium-server = with lib; {
    enable = mkEnableOption "trilium-server";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/trilium";
      description = ''
        The directory storing the nodes database and the configuration.
      '';
    };

    instanceName = mkOption {
      type = types.str;
      default = "Trilium";
      description = ''
        Instance name used to distinguish between different instances
      '';
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        The host address to bind to (defaults to localhost).
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8080;
      description = ''
        The port number to bind to.
      '';
    };

    nginx = mkOption {
      default = {};
      description = ''
        Configuration for nginx reverse proxy.
      '';

      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Configure the nginx reverse proxy settings.
            '';
          };

          hostName = mkOption {
            type = types.str;
            description = ''
              The hostname use to setup the virtualhost configuration
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
  {
    meta.maintainers = with lib.maintainers; [ kampka ];

    users.groups.trilium = {};
    users.users.trilium = {
      description = "Trilium User";
      group = "trilium";
      home = cfg.dataDir;
      isSystemUser = true;
    };

    systemd.services.trilium-server = {
      wantedBy = [ "multi-user.target" ];
      environment.TRILIUM_DATA_DIR = cfg.dataDir;
      serviceConfig = {
        ExecStart = "${pkgs.trilium-server}/bin/trilium-server";
        User = "trilium";
        Group = "trilium";
        PrivateTmp = "true";
      };
    };

    systemd.tmpfiles.rules = [
      "d  ${cfg.dataDir}            0750 trilium trilium - -"
      "L+ ${cfg.dataDir}/config.ini -    -       -       - ${configIni}"
    ];

  }

  (lib.mkIf cfg.nginx.enable {
    services.nginx = {
      enable = true;
      virtualHosts."${cfg.nginx.hostName}" = {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}/";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
          '';
        };
        extraConfig = ''
          client_max_body_size 0;
        '';
      };
    };
  })
  ]);
}
