{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let
  cfg = config.services.jitsi-meet;
in {
  options = {
    services.jitsi-meet = {
      enable = mkEnableOption "jitsi-meet";

      hostname = mkOption {
        default = "localhost";
        type = types.str;
        description = ''
          Sets the shared secret used to authenticate to the XMPP server.
        '';
      };

      domain = mkOption {
        type = types.str;
        default = "localdomain";
        description = ''
          Sets the shared secret used to authenticate to the XMPP server.
        '';
      };

      secret1 = mkOption {
        type = types.str;
        description = ''
          Sets the shared secret used to authenticate to the XMPP server.
        '';
      };

      secret2 = mkOption {
        type = types.str;
        description = ''
          Sets the shared secret used to authenticate to the XMPP server.
        '';
      };

      secret3 = mkOption {
        type = types.str;
        description = ''
          Sets the shared secret used to authenticate to the XMPP server.
        '';
      };

      configjs = mkOption {
        type = types.str;
        description = "config.js";
        default = ''
          var config = {
            hosts: {
              domain: '${cfg.hostname}.${cfg.domain}',
              muc: 'conference.${cfg.hostname}.${cfg.domain}',
              bridge: 'jitsi-videobridge.${cfg.hostname}.${cfg.domain}'
            },
              useNicks: false,
              bosh: '//${cfg.hostname}.${cfg.domain}/http-bind',
              desktopSharing: 'false'
            };
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open port in firewall for incoming connections.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    security.acme.certs = {
      "${cfg.hostname}.${cfg.domain}" = {
        group = "acme";
        allowKeysForGroup = true;
        postRun = ''
          systemctl restart prosody
        '';
      };
    };

    users.extraGroups.acme.members = [ "prosody" ];

    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall [ 80 443 ];

    services = {
      prosody = {
        enable = true;
        admins = [ "focus@auth.${cfg.hostname}.${cfg.domain}" ];
        modules = {
          bosh = true;
          httpserver = false;
          websocket = true;
        };
        extraModules = [ "pubsub" ];

        virtualHosts = {
          "${cfg.hostname}.${cfg.domain}" = {
            domain = "${cfg.hostname}.${cfg.domain}";
            enabled = true;
            ssl = {
              key = "/var/lib/acme/${cfg.hostname}.${cfg.domain}/key.pem";
              cert = "/var/lib/acme/${cfg.hostname}.${cfg.domain}/fullchain.pem";
            };
            extraConfig = ''
              authentication = "anonymous"
              modules_enabled = {
                "bosh";
                "pubsub";
              }
            '';
          };
          "auth.${cfg.hostname}.${cfg.domain}" = {
            domain = "auth.${cfg.hostname}.${cfg.domain}";
            enabled = true;
            extraConfig = ''
              authentication = "internal_plain"
            '';
          };
        };
        extraConfig = ''
          Component "conference.${cfg.hostname}.${cfg.domain}" "muc"
          Component "jitsi-videobridge.${cfg.hostname}.${cfg.domain}"
            component_secret = "${cfg.secret1}"
          Component "focus.${cfg.hostname}.${cfg.domain}"
            component_secret = "${cfg.secret2}"
        '';
      };

      jitsi-meet = {
        jitsi-videobridge = {
          enable = true;
          domain = "${cfg.hostname}.${cfg.domain}";
          port = 5347;
          host = "localhost";
          secret = cfg.secret1;
          openFirewall = cfg.openFirewall;
        };

        jicofo = {
          enable = true;
          secret = cfg.secret2;
          domain = "${cfg.hostname}.${cfg.domain}";
          userDomain = "auth.${cfg.hostname}.${cfg.domain}";
          userName = "focus";
          userPassword = cfg.secret3;
          openFirewall = cfg.openFirewall;
        };

        jitsi-meet = {
          enable = true;
          configjs = cfg.configjs;
        };
      };

      nginx = {
        enable = true;
        appendHttpConfig = ''
          server_names_hash_bucket_size  64;
        '';
        virtualHosts = {
          "${cfg.hostname}.${cfg.domain}" = {
            root = "${pkgs.jitsi-meet}/var/www";
            forceSSL = true;
            enableACME = true;
            locations = {
              "/" = {
                extraConfig = ''
                  ssi on;
                '';
              };
              "~ ^/([a-zA-Z0-9=\?]+)$" = {
                extraConfig = ''
                  rewrite ^/(.*)$ / break;
                '';
              };
              "/http-bind" = {
                extraConfig = ''
                  proxy_pass       http://localhost:5280/http-bind;
                  proxy_set_header X-Forwarded-For $remote_addr;
                  proxy_set_header Host $http_host;
                '';
              };
            };
            extraConfig = ''
              index index.html;
            '';
          };
        };
      };
    };
  };
}
