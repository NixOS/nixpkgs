{ config, lib, pkgs, ... }:

let
  version = "1.15.4";
  sha256 = "1nic4sg7n1q3fr4sj2j7xgv3a5p1gq4xccmx5msci1wwx62mfjfw";
  user = "osticket";
  stateDir = "/var/lib/${user}";

  inherit (lib) mkDefault mkEnableOption mkForce mkIf mkMerge mkOption;
  inherit (lib)
    concatStringsSep literalExpression mapAttrsToList optional optionals
    optionalString types;
  inherit (pkgs) fetchFromGitHub;

  cfg = config.services.osticket;

in
{
  # interface
  options = {
    services.osticket = {
      enable = mkEnableOption "the osTicket issue tracker with mysql and phpfpm+nginx";

      withSetup = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Include the setup wizard. Set this to false after setup.
        '';
      };

      favicon = mkOption {
        type = with types; nullOr path;
        default = null;
        description = ''
          Path to custom favicon PNG image. This will be added to the page &lt;HEAD&gt; sections.
        '';
      };

      # TODO make this nicer wrt getting the plugins, perhaps ship all plugins by default + allow extra
      plugins = mkOption {
        type = with types; attrsOf path;
        default = { };
        description = ''
          attrset with paths to plugins, like in nixos/modules/services/misc/osticket/plugins.nix
        '';
      };

      enablePolling = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to run email polling.";
      };

      poolConfig = mkOption {
        type = with types; attrsOf (oneOf [ str int bool ]);
        default = {
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.start_servers" = 1;
          "pm.min_spare_servers" = 1;
          "pm.max_spare_servers" = 2;
          "pm.max_requests" = 500;
          "php_value[date.timezone]" = "UTC";
          "php_value[upload_max_filesize]" = "10M";
          # Redirect worker stdout and stderr into main error log. If not set, stdout and
          # stderr will be redirected to /dev/null according to FastCGI specs.
          # Default Value: no
          "catch_workers_output" = true;
          "clear_env" = false;
          "env[\"SHELL_VERBOSITY\"]" = 3;
        };
        description = ''
          Options for the osTicket PHP pool. See the documentation on <literal>php-fpm.conf</literal>
          for details on configuration directives.
        '';
      };

      virtualHost = mkOption {
        type = types.submodule (import ../../web-servers/nginx/vhost-options.nix);
        example = literalExpression ''
          {
            serverName = "osticket.example.org";
            forceSSL = true;
            enableACME = true;
          }
        '';
        description = ''
          Nginx configuration can be done by adapting <option>services.nginx.virtualHosts</option>.
          See <xref linkend="opt-services.nginx.virtualHosts"/> for further information.
        '';
      };

    };
  };

  # implementation
  config = mkIf cfg.enable (
    let
      group = config.services.nginx.group;
      fpm = config.services.phpfpm.pools.${user};

      myPhp = pkgs.php74.buildEnv {
        extensions = { enabled, all }:
          enabled ++ (with all; [
            apcu
            gd
            gettext
            imap
            json
            mysqli
            mbstring
            # required but already in enabled
            # xml
            # Needed for Slack plugin
            # TODO extensions function on plugin definition
            #   that then gets mapped and joined
            curl
          ]);
        # extraConfig = "memory_limit=256M";
      };

      # The deploy uses git to get the version
      fakeGit = pkgs.writeScriptBin "git" ''
        #!${pkgs.stdenv.shell}
        echo ${version}
      '';

      pkg = pkgs.stdenv.mkDerivation rec {
        inherit version;
        pname = "osTicket";

        src = fetchFromGitHub {
          inherit sha256;
          owner = "osTicket";
          repo = "osTicket";
          rev = "v${version}";
        };

        # Provide php for patch-shebangs
        nativeBuildInputs = [ myPhp fakeGit ];

        patchPhase = ''
          # Patch the location of the config file and the version
          sed -i -e "s|INCLUDE_DIR.'ost-config.php'|'${stateDir}/ost-config.php'|" -e "s|define('GIT_VERSION', '\\$git')|define('GIT_VERSION', '${version}')|" bootstrap.php
          sed -i "s|../include|${stateDir}|" setup/install.php

          # Pre-populate the database settings for setup.
          # The password is not used but required.
          sed -i "s|'dbhost'=>'localhost'|'dbhost'=>'localhost','dbuser'=>'${user}','dbpass'=>'${user}','dbname'=>'${user}'|" setup/inc/install.inc.php

          # Add script header for cron
          sed -i '1i\#!/usr/bin/env php' api/cron.php
        '' + optionalString (cfg.favicon != null) ''
          cp ${cfg.favicon} images/favicon.png
          # Savings for 16x16 are tiny, just remove
          sed -i -e '/16x16/d' -e 's/oscar-favicon-32x32.png/favicon.png/' -e 's/ sizes="32x32"//' include/client/header.inc.php include/staff/header.inc.php
        '';

        installPhase = ''
          mkdir -p $out/public
          php manage.php deploy ${
            optionalString cfg.withSetup "--setup"
          } -i $out/include $out/public
          chmod a+x $out/public/manage.php $out/public/api/cron.php $out/public/api/pipe.php
          mkdir -p $out/bin
          ln -s ../public/manage.php $out/bin/osticket_manage
          ln -s ../public/api/cron.php $out/bin/osticket_cron
          ln -s ../public/api/pipe.php $out/bin/osticket_pipe
        '' + (concatStringsSep "\n" (mapAttrsToList
          (name: path: "ln -s ${path} $out/include/plugins/${name}")
          cfg.plugins));

        meta = with pkgs.lib; {
          homepage = "https://osticket.com/";
          description = "Issue tracking system";
          platforms = platforms.linux;
          maintainers = [ maintainers.wmertens ];
          license = licenses.gpl2;
        };
      };

    in
    {
      users.users.${user} = {
        group = group;
        useDefaultShell = true;
        isSystemUser = true;
        packages = [ myPhp pkg pkgs.mariadb ];
      };

      systemd.tmpfiles.rules = [
        "d '${stateDir}' 0750 ${user} ${group} - -"
        "C '${stateDir}/ost-config.php' ${
        if cfg.withSetup then "0640" else "0440"
      } ${user} ${group} - ${pkg}/include/ost-sampleconfig.php"
      ];

      # It would be nice to replace this with fetchmail which has IMAP IDLE
      # That way, tickets would be seen immediately
      systemd.services."${user}-cron" = mkIf cfg.enablePolling {
        description = "osTicket email polling";
        serviceConfig.ExecStart = "${myPhp}/bin/php ${pkg}/api/cron.php";
        # We run this every minute but osTicket has its own timers
        startAt = "*:0/1";
        serviceConfig = {
          Type = "oneshot";
          User = user;
          Group = group;
          TimeoutStartSec = "1m";
        };
      };

      services.phpfpm.pools.${user} = {
        inherit user group;
        phpPackage = myPhp;
        settings = {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        } // cfg.poolConfig;
      };

      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        ensureDatabases = [ "osticket" ];
        ensureUsers = [{
          name = "osticket";
          ensurePermissions = { "osticket.*" = "ALL PRIVILEGES"; };
        }];
      };

      services.nginx = {
        enable = true;

        recommendedGzipSettings = mkDefault true;
        recommendedOptimisation = mkDefault true;
        recommendedProxySettings = mkDefault true;
        recommendedTlsSettings = mkDefault true;

        virtualHosts.${cfg.virtualHost.serverName} = mkMerge [
          cfg.virtualHost
          {
            root = mkForce "${pkg}/public";

            locations = {
              "/" = { index = "index.php"; };

              # Deny access to apache .ht* files (nginx doesn't use these)
              "~ /.ht" = { return = "403"; };

              # /api/*.* should be handled by /api/http.php if the requested file does not exist
              "/api" = {
                tryFiles = "$uri $uri/ /api/http.php$is_args$args";
              };

              # /apps/*.* should be handled by /apps/dispatcher.php if the requested file does not exist
              "/apps" = {
                tryFiles = "$uri $uri/ /apps/dispatcher.php$is_args$args";
              };

              "~ [^/]\\.php($|/)" = {
                fastcgiParams =
                  { PATH_INFO = "$fastcgi_path_info"; };

                extraConfig = ''
                  fastcgi_pass unix:${fpm.socket};

                  fastcgi_split_path_info ^(.+\.php)(/.*)$;
                  if (!-f $document_root$fastcgi_script_name) {
                      return 404;
                  }
                '';
              };
            };
          }
        ];

      };
    }
  );
}
