{ config, lib, pkgs, ... }:

with lib;

let

  uchiwa = pkgs.uchiwa;

  cfg = config.flyingcircus.services.uchiwa;

  uchiwa_json = pkgs.writeText "uchiwa.json" ''
    {
      "sensu": [
        {
          "name": "Local Site",
          "host": "localhost",
          "port": 4567
        }
      ],
      "uchiwa": {
        "host": "0.0.0.0",
        "port": 3000
      }
    }
  '';

in {

  options = {

    flyingcircus.services.uchiwa = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Uchiwa sensu dashboard daemon.
        '';
      };
      config = mkOption {
        type = types.lines;
        description = ''
          Contents of the uchiwa configuration file.
        '';
      };
      extraOpts = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Extra options used when launching uchiwa.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    ids.gids.uchiwa = 209;
    ids.uids.uchiwa = 209;

    services.nginx.enable = true;
    services.nginx.httpConfig = ''


    server {
        listen [2a01:1e8:e100:828f:feaa:14ff:fe8f:94ba]:80;
        server_name sensu-beta.flyingcircus.io;
        rewrite (.*) https://$server_name$1 permanent;
    }

    server {

        listen [2a01:1e8:e100:828f:feaa:14ff:fe8f:94ba]:443;
        server_name sensu-beta.flyingcircus.io;

        ssl on;
        ssl_certificate /etc/ssl/sensu-beta.flyingcircus.io-2016014.crt;
        ssl_certificate_key /etc/ssl/sensu-beta.flyingcircus.io-2016014.key;
        add_header Strict-Transport-Security max-age=31536000;

        ssl_prefer_server_ciphers on;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers "EECDH+AESGCM EDH+AESGCM EECDH EDH RSA+3DES -RC4 -aNULL -eNULL -LOW -MD5 -EXP -PSK -DSS -ADH";
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;

        ssl_dhparam /etc/ssl/dhparams.pem;

        auth_basic           "sensu";
        auth_basic_user_file /etc/local/sensu.htpasswd;

        location / {
            proxy_pass http://localhost:3000;
        }

    }


'';

    networking.firewall.allowedTCPPorts = [ 443 80 ];

    users.extraGroups.uchiwa.gid = config.ids.gids.uchiwa;

    users.extraUsers.uchiwa = {
      description = "uchiwa daemon user";
      uid = config.ids.uids.uchiwa;
      group = "uchiwa";
    };

    systemd.services.uchiwa = {
      wantedBy = [ "multi-user.target" ];
      path = [ uchiwa ];
      serviceConfig = {
        User = "uchiwa";
        ExecStart = "${uchiwa}/bin/uchiwa -c ${uchiwa_json} -p ${uchiwa}/public";
      };
    };

  };

}
