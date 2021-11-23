{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lms;
  settingsFormat = pkgs.formats.toml {};
in
{
  options.services.lms = {
    enable = mkEnableOption "LMS (Lightweight Music Server). A self-hosted, music streaming server";

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/lms";
      description = ''
        The directory where lms uses as a working directory to store its state.
        If left as the default value this directory will automatically be
        created before the lms server starts, otherwise the sysadmin is
        responsible for ensuring the directory exists with appropriate ownership
        and permissions.
      '';
    };

    virtualHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Name of the nginx virtualhost to setup as reverse proxy. If null, do
        not setup any virtualhost.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "lms";
      description = ''
        User account under which LMS runs. If left as the default value this
        user will automatically be created on system activation, otherwise the
        sysadmin is responsible for ensuring the user exists before the lms
        service starts.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          listen-addr = mkOption {
           type = types.str;
           default = "127.0.0.1";
           description = ''
             The address on which to bind LMS.
           '';
          };

          listen-port = mkOption {
           type = types.port;
           default = 5082;
           description = ''
             The port on which LMS will listen to.
           '';
          };

          api-subsonic = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enable the Subsonic API.
            '';
          };
        };
      };
      default = {};
      description = ''
        Configuration for LMS, see
        <link xlink:href="https://github.com/epoupon/lms/blob/master/conf/lms.conf"/>
        for full list of supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.lms.settings = {
      working-dir = cfg.stateDir;
      behind-reverse-proxy = cfg.virtualHost != null;
      docroot = "${pkgs.lms}/share/lms/docroot/;/resources,/css,/images,/js,/favicon.ico";
      approot = "${pkgs.lms}/share/lms/approot";
      cover-max-file-size = mkDefault 10;
      cover-max-cache-size = mkDefault 30;
    };

    systemd.services.lms = {
      description = "Lightweight Music Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = mkMerge [
        {
          ExecStart =
            let lmsConfig = settingsFormat.generate "lms.conf" cfg.settings;
            in "${pkgs.lms}/bin/lms ${lmsConfig}";
          Restart = "on-failure";
          RestartSec = 5;
          User = cfg.user;
          Group = "lms";
          WorkingDirectory = cfg.stateDir;
          UMask = "0022";

          NoNewPrivileges = true;
          ProtectSystem = true;
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
        }
        (mkIf (cfg.stateDir == "/var/lib/lms") {
          StateDirectory = "/var/lib/lms";
        })
      ];
    };

    # from: https://github.com/epoupon/lms#reverse-proxy-settings
    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      virtualHosts.${cfg.virtualHost} = {
        locations."/" = {
          proxyPass = "http://${cfg.listenAddress}:${toString cfg.port}";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_read_timeout 120;
          '';
        };
        extraConfig = ''
          proxy_request_buffering off;
          proxy_buffering off;
          proxy_buffer_size 4k;
          proxy_read_timeout 10m;
          proxy_send_timeout 10m;
          keepalive_timeout 10m;
        '';
      };
    };

    users.users = mkIf (cfg.user == "lms") {
      ${cfg.user} = {
        isSystemUser = true;
        description = "LMS service user";
        name = cfg.user;
        group = "lms";
        home = cfg.stateDir;
      };
    };

    users.groups.lms = {};
  };
}
