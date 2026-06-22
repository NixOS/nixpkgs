{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kasmweb;
in
{
  options.services.kasmweb = {
    enable = lib.mkEnableOption "kasmweb";

    networkSubnet = lib.mkOption {
      default = "172.20.0.0/16";
      type = lib.types.str;
      description = ''
        The network subnet to use for the containers.
      '';
    };

    postgres = {
      user = lib.mkOption {
        default = "kasmweb";
        type = lib.types.str;
        description = ''
          Username to use for the postgres database.
        '';
      };
      password = lib.mkOption {
        default = "kasmweb";
        type = lib.types.str;
        description = ''
          password to use for the postgres database.
        '';
      };
    };

    redisPassword = lib.mkOption {
      default = "kasmweb";
      type = lib.types.str;
      description = ''
        password to use for the redis cache.
      '';
    };

    defaultAdminPassword = lib.mkOption {
      default = "kasmweb";
      type = lib.types.str;
      description = ''
        default admin password to use.
      '';
    };

    defaultUserPassword = lib.mkOption {
      default = "kasmweb";
      type = lib.types.str;
      description = ''
        default user password to use.
      '';
    };

    defaultManagerToken = lib.mkOption {
      default = "kasmweb";
      type = lib.types.str;
      description = ''
        default manager token to use.
      '';
    };

    defaultGuacToken = lib.mkOption {
      default = "kasmweb";
      type = lib.types.str;
      description = ''
        default guac token to use.
      '';
    };

    defaultRegistrationToken = lib.mkOption {
      default = "kasmweb";
      type = lib.types.str;
      description = ''
        default registration token to use.
      '';
    };

    datastorePath = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/kasmweb";
      description = ''
        The directory used to store all data for kasmweb.
      '';
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = ''
        The address on which kasmweb should listen.
      '';
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 443;
      description = ''
        The port on which kasmweb should listen.
      '';
    };

    sslCertificate = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        The SSL certificate to be used for kasmweb.
      '';
    };

    sslCertificateKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        The SSL certificate's key to be used for kasmweb. Make sure to specify
        this as a string and not a literal path, so that it is not accidentally
        included in your nixstore.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = {
      "init-kasmweb" = {
        wantedBy = [
          "docker-kasm_db.service"
          "podman-kasm_db.service"
        ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          TimeoutStartSec = 300;
          ExecStart = pkgs.replaceVarsWith {
            src = ./initialize_kasmweb.sh;
            isExecutable = true;
            replacements = {
              binPath = lib.makeBinPath [
                pkgs.docker
                pkgs.openssl
                pkgs.gnused
                pkgs.yq-go
              ];
              runtimeShell = pkgs.runtimeShell;
              kasmweb = pkgs.kasmweb;
              postgresUser = "postgres";
              postgresPassword = "postgres";
              inherit (cfg)
                datastorePath
                sslCertificate
                sslCertificateKey
                redisPassword
                networkSubnet
                defaultUserPassword
                defaultAdminPassword
                defaultManagerToken
                defaultRegistrationToken
                defaultGuacToken
                ;
            };
          };
        };
      };
    };

    virtualisation = {
      oci-containers.backend = "docker";
      oci-containers.containers = {
        kasm_db = {
          image = "postgres:16-alpine";
          autoStart = true;
          environment = {
            POSTGRES_PASSWORD = "postgres";
            POSTGRES_USER = "postgres";
            POSTGRES_DB = "kasm";
          };
          volumes = [
            "${cfg.datastorePath}/conf/database/data.sql:/docker-entrypoint-initdb.d/data.sql"
            "${cfg.datastorePath}/conf/database/:/tmp/"
            "kasmweb_db:/var/lib/postgresql/data"
          ];
          extraOptions = [ "--network=kasm_default_network" ];
        };
        kasm_db_init = {
          image = "kasmweb/api:${pkgs.kasmweb.version}";
          user = "root:root";
          autoStart = true;
          volumes = [
            "${cfg.datastorePath}/:/opt/kasm/current/"
            "kasmweb_api_data:/tmp"
          ];
          dependsOn = [ "kasm_db" ];
          entrypoint = "/bin/bash";
          cmd = [ "/opt/kasm/current/init_seeds.sh" ];
          extraOptions = [
            "--network=kasm_default_network"
            "--userns=host"
          ];
        };
        kasm_redis = {
          image = "redis:5-alpine";
          entrypoint = "/bin/sh";
          autoStart = true;
          cmd = [
            "-c"
            "redis-server --requirepass ${cfg.redisPassword}"
          ];
          extraOptions = [
            "--network=kasm_default_network"
            "--userns=host"
          ];
        };
        kasm_api = {
          image = "kasmweb/api:${pkgs.kasmweb.version}";
          autoStart = false;
          user = "root:root";
          volumes = [
            "${cfg.datastorePath}/:/opt/kasm/current/"
            "kasmweb_api_data:/tmp"
          ];
          dependsOn = [ "kasm_db_init" ];
          extraOptions = [
            "--network=kasm_default_network"
            "--userns=host"
          ];
        };
        kasm_manager = {
          image = "kasmweb/manager:${pkgs.kasmweb.version}";
          autoStart = false;
          user = "root:root";
          volumes = [
            "${cfg.datastorePath}/:/opt/kasm/current/"
          ];
          dependsOn = [
            "kasm_db_init"
            "kasm_db"
            "kasm_api"
          ];
          extraOptions = [
            "--network=kasm_default_network"
            "--userns=host"
            "--read-only"
          ];
        };
        kasm_agent = {
          image = "kasmweb/agent:${pkgs.kasmweb.version}";
          autoStart = false;
          user = "root:root";
          volumes = [
            "${cfg.datastorePath}/:/opt/kasm/current/"
            "/var/run/docker.sock:/var/run/docker.sock"
            "${pkgs.docker}/bin/docker:/usr/bin/docker"
            "${cfg.datastorePath}/conf/nginx:/etc/nginx/conf.d"
          ];
          dependsOn = [ "kasm_manager" ];
          extraOptions = [
            "--network=kasm_default_network"
            "--userns=host"
            "--read-only"
          ];
        };
        kasm_share = {
          image = "kasmweb/share:${pkgs.kasmweb.version}";
          autoStart = false;
          user = "root:root";
          volumes = [
            "${cfg.datastorePath}/:/opt/kasm/current/"
          ];
          dependsOn = [
            "kasm_db_init"
            "kasm_db"
            "kasm_redis"
          ];
          extraOptions = [
            "--network=kasm_default_network"
            "--userns=host"
            "--read-only"
          ];
        };
        kasm_guac = {
          image = "kasmweb/kasm-guac:${pkgs.kasmweb.version}";
          autoStart = false;
          user = "root:root";
          volumes = [
            "${cfg.datastorePath}/:/opt/kasm/current/"
          ];
          dependsOn = [
            "kasm_db"
            "kasm_redis"
          ];
          extraOptions = [
            "--network=kasm_default_network"
            "--userns=host"
            "--read-only"
          ];
        };
        kasm_proxy = {
          image = "kasmweb/nginx:latest";
          autoStart = false;
          ports = [ "${cfg.listenAddress}:${toString cfg.listenPort}:443" ];
          user = "root:root";
          volumes = [
            "${cfg.datastorePath}/conf/nginx:/etc/nginx/conf.d:ro"
            "${cfg.datastorePath}/certs/kasm_nginx.key:/etc/ssl/private/kasm_nginx.key"
            "${cfg.datastorePath}/certs/kasm_nginx.crt:/etc/ssl/certs/kasm_nginx.crt"
            "${cfg.datastorePath}/www:/srv/www:ro"
            "${cfg.datastorePath}/log/nginx:/var/log/external/nginx"
            "${cfg.datastorePath}/log/logrotate:/var/log/external/logrotate"
          ];
          dependsOn = [
            "kasm_manager"
            "kasm_api"
            "kasm_agent"
            "kasm_share"
            "kasm_guac"
          ];
          extraOptions = [
            "--network=kasm_default_network"
            "--userns=host"
            "--network-alias=proxy"
          ];
        };
      };
    };
  };
}
