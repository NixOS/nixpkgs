{ config, lib, pkgs, ... }:

with lib;

let
  inherit (lib) mkDefault mkEnableOption mkForce mkIf mkMerge mkOption types;
  inherit (lib) concatStringsSep literalExpression mapAttrsToList mapAttrs' nameValuePair filterAttrs mapAttrs optional optionalString;
  dataDirForInstance = instanceName: "/var/www/${cfg.user}/${instanceName}"; # compute data directory for an instance.
  cfg = config.services.hotcrp;

  phpExt = pkgs.php81.buildEnv {
    extensions = { all, ... }: with all; [ mbstring intl mysqlnd ];
  };
in
  {
  # Interface
  options.services.hotcrp = {
    enable = mkEnableOption (lib.mdDoc "Hotcrp web application");
    package = lib.mkPackageOption pkgs "hotcrp" { };
    user = mkOption {
      type = lib.types.str;
      description = "username of the hotcrp server process owner.";
      default = "hotcrp";
    };

    group = mkOption {
      type = lib.types.str;
      description = "group of the hotcrp server process owner.";
      default = "hotcrp";
    };

    nginx.enable = mkEnableOption (lib.mdDoc "configure NGINX  hosts for Hotcrp instances.");

    instances = mkOption {
      type = types.attrsOf (types.submodule rec { options = {
        nginxVirtualHost = mkOption {
          type = lib.types.str;
          description = "Nginx virtual host of this hotcrp instance";
          default = null;
        };

        hotcrpPhpConfOptions = mkOption {
          type = lib.types.attrs;
          description = "key-value pairs that populate the HotCRP 'conf/options.php' file";
          default = {};
        };
      }; });
      default = {};
    };
  };
  # Implementation
  config =
    let
      virtualHosts = filter (host: host != null) (mapAttrsToList (k: opts: opts.nginxVirtualHost) cfg.instances);
    in
    {
      assertions = [ { assertion = false; message = "assert(false)"; } ];
      warnings = optional (!cfg.nginx.enable && !(isEmpty virtualHosts))  ''
        Nginx virtual host is disabled, while instances are defined.
        Please ensure that custom routing logic has been setup to route to the following subdomains:
        '${toString virtualHosts}'.
      '' ++
      optional (!cfg.enable && !(isEmpty virtualHosts)) ''
        hotcrp package is disabled while instances are defined. Is this intentional?
      '';
    } //
    mkIf cfg.enable {
      services.hotcrp.package = /nix/store/97brvli3b84fanm8sshr6l8zc0zygwk6-hotcrp-v3.0b3;
      services.mysql = {
        enable = true;
        package = mkDefault pkgs.mariadb;
        ensureUsers = [
          { name = cfg.user;
          ensurePermissions = mapAttrs' (key: opts:
                # for all tables in the database named ${key}, give the hotcrp user full privileges.
                nameValuePair (key + ".*") "ALL PRIVILEGES"
                ) cfg.instances;
              } ];
            };

    # 80: HTTP
    # 442: HTTPS
    # 25, 465, 587: sendmail.
    # 23: telnet
    networking.firewall.allowedTCPPorts = [ 80 443 25 465 587 23 ];
    networking.firewall.allowedUDPPorts = [ 465 587 23 ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      createHome = true;
      group  = cfg.group;
      extraGroups = [config.services.mysql.group "wheel" "sudoers"]; #just in case.
    };

    users.groups.${cfg.group} = {};

    # pool for icfp24
    services.phpfpm.phpOptions = ''
      display_errors = on;
      log_errors = on;
      upload_max_filesize = 15M;
      max_input_vars = 4096;
      post_max_size = 20M;
      session.gc_maxlifetime = 86400;
    '';


    # pools
    services.phpfpm.pools = mapAttrs (key: opts: {
      user = cfg.user;
      group = cfg.group;

      settings = {
        pm = "dynamic";
        "listen.owner" = config.services.nginx.user;
        "pm.max_children" = 5;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 3;
        "pm.max_requests" = 500;
      };

    }) cfg.instances;


    services.nginx = mkIf (cfg.nginx.enable) {
      enable = true;
      enableReload = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts = mapAttrs' (key: opts:
      nameValuePair
      (opts.nginxVirtualHost)
      ({
        root = dataDirForInstance key;
        addSSL = true;
        enableACME = true;
        locations."/" = {
          root = dataDirForInstance key;
          extraConfig = ''
                try_files $uri $uri/ /index.php?$args;
                rewrite ^ /index.php;
          '';
        };
        locations."~ \\.php$" = {
          root = dataDirForInstance key;
          extraConfig = ''
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass  unix:${config.services.phpfpm.pools.${key}.socket};
              fastcgi_index index.php;
              include ${pkgs.nginx}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
          '';
        };

      }))
      (filterAttrs (key: opts: opts.nginxVirtualHost != null) cfg.instances);
    };

    systemd.services = mapAttrs' (key: opts:
    let
      dataDir = dataDirForInstance key;
      hotcrpPhpConfOptions =
        ''// ==Nix generated option from 'hotcrpPhpConfOptions'==

        '' +
        concatLines (mapAttrsToList (k: v: ''$Opt["${k}"] = "${v}";'') opts.hotcrpPhpConfOptions);
    in
    nameValuePair (key + "-init") ({
      wantedBy = [ "multi-user.target" ];
      after = [ "phpfpm-${key}.service" "mysql.service" ]; # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-servers/phpfpm/default.nix
      serviceConfig = { User = "root"; Type = "oneshot"; }; # TODO: change to `cfg.user` and remove the `chown` below.
      path = [cfg.package config.services.mysql.package pkgs.coreutils pkgs.gawk pkgs.unixtools.procps pkgs.stdenv];
      enable = true;
      script = ''
        set -o xtrace
        set -euo pipefail
        whoami
        if [[ ! -d ${dataDir} ]]; then
        echo "hotcrp: unable to find directory '${dataDir}' for ${key}, creating it and initializing the database..."
        mkdir -p ${dataDir} || (mv ${dataDir} ${dataDir}.old && exit 1)
        cp -r ${cfg.package}/* ${dataDir}/ || (mv ${dataDir} ${dataDir}.old && exit 1)
        cd ${dataDir} # everything below is in dataDir
        ./lib/createdb.sh --batch ${key} --replace || (mv ${dataDir} ${dataDir}.old && exit 1)
        chown -R ${cfg.user}:${cfg.group} . || (mv ${dataDir} ${dataDir}.old && exit 1)
        chmod 777 -R  . || (mv ${dataDir} ${dataDir}.old && exit 1)
        chmod 777 -R  /home/
        chmod 777 -R  /home/${cfg.user}/
        echo '${hotcrpPhpConfOptions}' >> ${dataDir}/conf/options.php
        fi
        echo "hotcrp: Success! '${dataDir}' exists, exiting. (To force re-initialization, please delete '${dataDir}')".
      '';
    })
    ) config.services.hotcrp.instances;
  };
}
