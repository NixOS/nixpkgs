{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.dokuwiki;
  eachSite = cfg.sites;
  user = "dokuwiki";
  webserver = config.services.${cfg.webserver};
  stateDir = hostName: "/var/lib/dokuwiki/${hostName}/data";

  dokuwikiAclAuthConfig = hostName: cfg: pkgs.writeText "acl.auth-${hostName}.php" ''
    # acl.auth.php
    # <?php exit()?>
    #
    # Access Control Lists
    #
    ${toString cfg.acl}
  '';

  dokuwikiLocalConfig = hostName: cfg: pkgs.writeText "local-${hostName}.php" ''
    <?php
    $conf['savedir'] = '${cfg.stateDir}';
    $conf['superuser'] = '${toString cfg.superUser}';
    $conf['useacl'] = '${toString cfg.aclUse}';
    $conf['disableactions'] = '${cfg.disableActions}';
    ${toString cfg.extraConfig}
  '';

  dokuwikiPluginsLocalConfig = hostName: cfg: pkgs.writeText "plugins.local-${hostName}.php" ''
    <?php
    ${cfg.pluginsConfig}
  '';


  pkg = hostName: cfg: pkgs.stdenv.mkDerivation rec {
    pname = "dokuwiki-${hostName}";
    version = src.version;
    src = cfg.package;

    installPhase = ''
      mkdir -p $out
      cp -r * $out/

      # symlink the dokuwiki config
      ln -s ${dokuwikiLocalConfig hostName cfg} $out/share/dokuwiki/local.php

      # symlink plugins config
      ln -s ${dokuwikiPluginsLocalConfig hostName cfg} $out/share/dokuwiki/plugins.local.php

      # symlink acl
      ln -s ${dokuwikiAclAuthConfig hostName cfg} $out/share/dokuwiki/acl.auth.php

      # symlink additional plugin(s) and templates(s)
      ${concatMapStringsSep "\n" (template: "ln -s ${template} $out/share/dokuwiki/lib/tpl/${template.name}") cfg.templates}
      ${concatMapStringsSep "\n" (plugin: "ln -s ${plugin} $out/share/dokuwiki/lib/plugins/${plugin.name}") cfg.plugins}
    '';
  };

  siteOpts = { config, lib, name, ... }:
    {
      options = {
        enable = mkEnableOption (lib.mdDoc "DokuWiki web application.");

        package = mkOption {
          type = types.package;
          default = pkgs.dokuwiki;
          defaultText = literalExpression "pkgs.dokuwiki";
          description = lib.mdDoc "Which DokuWiki package to use.";
        };

        stateDir = mkOption {
          type = types.path;
          default = "/var/lib/dokuwiki/${name}/data";
          description = lib.mdDoc "Location of the DokuWiki state directory.";
        };

        acl = mkOption {
          type = types.nullOr types.lines;
          default = null;
          example = "*               @ALL               8";
          description = lib.mdDoc ''
            Access Control Lists: see <https://www.dokuwiki.org/acl>
            Mutually exclusive with services.dokuwiki.aclFile
            Set this to a value other than null to take precedence over aclFile option.

            Warning: Consider using aclFile instead if you do not
            want to store the ACL in the world-readable Nix store.
          '';
        };

        aclFile = mkOption {
          type = with types; nullOr str;
          default = if (config.aclUse && config.acl == null) then "/var/lib/dokuwiki/${name}/acl.auth.php" else null;
          description = lib.mdDoc ''
            Location of the dokuwiki acl rules. Mutually exclusive with services.dokuwiki.acl
            Mutually exclusive with services.dokuwiki.acl which is preferred.
            Consult documentation <https://www.dokuwiki.org/acl> for further instructions.
            Example: <https://github.com/splitbrain/dokuwiki/blob/master/conf/acl.auth.php.dist>
          '';
          example = "/var/lib/dokuwiki/${name}/acl.auth.php";
        };

        aclUse = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Necessary for users to log in into the system.
            Also limits anonymous users. When disabled,
            everyone is able to create and edit content.
          '';
        };

        pluginsConfig = mkOption {
          type = types.lines;
          default = ''
            $plugins['authad'] = 0;
            $plugins['authldap'] = 0;
            $plugins['authmysql'] = 0;
            $plugins['authpgsql'] = 0;
          '';
          description = lib.mdDoc ''
            List of the dokuwiki (un)loaded plugins.
          '';
        };

        superUser = mkOption {
          type = types.nullOr types.str;
          default = "@admin";
          description = lib.mdDoc ''
            You can set either a username, a list of usernames (“admin1,admin2”),
            or the name of a group by prepending an @ char to the groupname
            Consult documentation <https://www.dokuwiki.org/config:superuser> for further instructions.
          '';
        };

        usersFile = mkOption {
          type = with types; nullOr str;
          default = if config.aclUse then "/var/lib/dokuwiki/${name}/users.auth.php" else null;
          description = lib.mdDoc ''
            Location of the dokuwiki users file. List of users. Format:

                login:passwordhash:Real Name:email:groups,comma,separated

            Create passwordHash easily by using:

                mkpasswd -5 password `pwgen 8 1`

            Example: <https://github.com/splitbrain/dokuwiki/blob/master/conf/users.auth.php.dist>
            '';
          example = "/var/lib/dokuwiki/${name}/users.auth.php";
        };

        disableActions = mkOption {
          type = types.nullOr types.str;
          default = "";
          example = "search,register";
          description = lib.mdDoc ''
            Disable individual action modes. Refer to
            <https://www.dokuwiki.org/config:action_modes>
            for details on supported values.
          '';
        };

        plugins = mkOption {
          type = types.listOf types.path;
          default = [];
          description = lib.mdDoc ''
                List of path(s) to respective plugin(s) which are copied from the 'plugin' directory.

                ::: {.note}
                These plugins need to be packaged before use, see example.
                :::
          '';
          example = literalExpression ''
                let
                  # Let's package the icalevents plugin
                  plugin-icalevents = pkgs.stdenv.mkDerivation {
                    name = "icalevents";
                    # Download the plugin from the dokuwiki site
                    src = pkgs.fetchurl {
                      url = "https://github.com/real-or-random/dokuwiki-plugin-icalevents/releases/download/2017-06-16/dokuwiki-plugin-icalevents-2017-06-16.zip";
                      sha256 = "e40ed7dd6bbe7fe3363bbbecb4de481d5e42385b5a0f62f6a6ce6bf3a1f9dfa8";
                    };
                    sourceRoot = ".";
                    # We need unzip to build this package
                    buildInputs = [ pkgs.unzip ];
                    # Installing simply means copying all files to the output directory
                    installPhase = "mkdir -p $out; cp -R * $out/";
                  };
                # And then pass this theme to the plugin list like this:
                in [ plugin-icalevents ]
          '';
        };

        templates = mkOption {
          type = types.listOf types.path;
          default = [];
          description = lib.mdDoc ''
                List of path(s) to respective template(s) which are copied from the 'tpl' directory.

                ::: {.note}
                These templates need to be packaged before use, see example.
                :::
          '';
          example = literalExpression ''
                let
                  # Let's package the bootstrap3 theme
                  template-bootstrap3 = pkgs.stdenv.mkDerivation {
                    name = "bootstrap3";
                    # Download the theme from the dokuwiki site
                    src = pkgs.fetchurl {
                      url = "https://github.com/giterlizzi/dokuwiki-template-bootstrap3/archive/v2019-05-22.zip";
                      sha256 = "4de5ff31d54dd61bbccaf092c9e74c1af3a4c53e07aa59f60457a8f00cfb23a6";
                    };
                    # We need unzip to build this package
                    buildInputs = [ pkgs.unzip ];
                    # Installing simply means copying all files to the output directory
                    installPhase = "mkdir -p $out; cp -R * $out/";
                  };
                # And then pass this theme to the template list like this:
                in [ template-bootstrap3 ]
          '';
        };

        poolConfig = mkOption {
          type = with types; attrsOf (oneOf [ str int bool ]);
          default = {
            "pm" = "dynamic";
            "pm.max_children" = 32;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 4;
            "pm.max_requests" = 500;
          };
          description = lib.mdDoc ''
            Options for the DokuWiki PHP pool. See the documentation on `php-fpm.conf`
            for details on configuration directives.
          '';
        };

        extraConfig = mkOption {
          type = types.nullOr types.lines;
          default = null;
          example = ''
            $conf['title'] = 'My Wiki';
            $conf['userewrite'] = 1;
          '';
          description = lib.mdDoc ''
            DokuWiki configuration. Refer to
            <https://www.dokuwiki.org/config>
            for details on supported values.
          '';
        };

      };

    };
in
{
  # interface
  options = {
    services.dokuwiki = {

      sites = mkOption {
        type = types.attrsOf (types.submodule siteOpts);
        default = {};
        description = lib.mdDoc "Specification of one or more DokuWiki sites to serve";
      };

      webserver = mkOption {
        type = types.enum [ "nginx" "caddy" ];
        default = "nginx";
        description = lib.mdDoc ''
          Whether to use nginx or caddy for virtual host management.

          Further nginx configuration can be done by adapting `services.nginx.virtualHosts.<name>`.
          See [](#opt-services.nginx.virtualHosts) for further information.

          Further apache2 configuration can be done by adapting `services.httpd.virtualHosts.<name>`.
          See [](#opt-services.httpd.virtualHosts) for further information.
        '';
      };

    };
  };

  # implementation
  config = mkIf (eachSite != {}) (mkMerge [{

    assertions = flatten (mapAttrsToList (hostName: cfg:
    [{
      assertion = cfg.aclUse -> (cfg.acl != null || cfg.aclFile != null);
      message = "Either services.dokuwiki.sites.${hostName}.acl or services.dokuwiki.sites.${hostName}.aclFile is mandatory if aclUse true";
    }
    {
      assertion = cfg.usersFile != null -> cfg.aclUse != false;
      message = "services.dokuwiki.sites.${hostName}.aclUse must must be true if usersFile is not null";
    }
    ]) eachSite);

    services.phpfpm.pools = mapAttrs' (hostName: cfg: (
      nameValuePair "dokuwiki-${hostName}" {
        inherit user;
        group = webserver.group;

        phpPackage = pkgs.php81;
        phpEnv = {
          DOKUWIKI_LOCAL_CONFIG = "${dokuwikiLocalConfig hostName cfg}";
          DOKUWIKI_PLUGINS_LOCAL_CONFIG = "${dokuwikiPluginsLocalConfig hostName cfg}";
        } // optionalAttrs (cfg.usersFile != null) {
          DOKUWIKI_USERS_AUTH_CONFIG = "${cfg.usersFile}";
        } //optionalAttrs (cfg.aclUse) {
          DOKUWIKI_ACL_AUTH_CONFIG = if (cfg.acl != null) then "${dokuwikiAclAuthConfig hostName cfg}" else "${toString cfg.aclFile}";
        };

        settings = {
          "listen.owner" = webserver.user;
          "listen.group" = webserver.group;
        } // cfg.poolConfig;
      }
    )) eachSite;

  }

  {
    systemd.tmpfiles.rules = flatten (mapAttrsToList (hostName: cfg: [
      "d ${stateDir hostName}/attic 0750 ${user} ${webserver.group} - -"
      "d ${stateDir hostName}/cache 0750 ${user} ${webserver.group} - -"
      "d ${stateDir hostName}/index 0750 ${user} ${webserver.group} - -"
      "d ${stateDir hostName}/locks 0750 ${user} ${webserver.group} - -"
      "d ${stateDir hostName}/media 0750 ${user} ${webserver.group} - -"
      "d ${stateDir hostName}/media_attic 0750 ${user} ${webserver.group} - -"
      "d ${stateDir hostName}/media_meta 0750 ${user} ${webserver.group} - -"
      "d ${stateDir hostName}/meta 0750 ${user} ${webserver.group} - -"
      "d ${stateDir hostName}/pages 0750 ${user} ${webserver.group} - -"
      "d ${stateDir hostName}/tmp 0750 ${user} ${webserver.group} - -"
    ] ++ lib.optional (cfg.aclFile != null) "C ${cfg.aclFile} 0640 ${user} ${webserver.group} - ${pkg hostName cfg}/share/dokuwiki/conf/acl.auth.php.dist"
    ++ lib.optional (cfg.usersFile != null) "C ${cfg.usersFile} 0640 ${user} ${webserver.group} - ${pkg hostName cfg}/share/dokuwiki/conf/users.auth.php.dist"
    ) eachSite);

    users.users.${user} = {
      group = webserver.group;
      isSystemUser = true;
    };
  }

  (mkIf (cfg.webserver == "nginx") {
    services.nginx = {
      enable = true;
      virtualHosts = mapAttrs (hostName: cfg: {
        serverName = mkDefault hostName;
        root = "${pkg hostName cfg}/share/dokuwiki";

        locations = {
          "~ /(conf/|bin/|inc/|install.php)" = {
            extraConfig = "deny all;";
          };

          "~ ^/data/" = {
            root = "${stateDir hostName}";
            extraConfig = "internal;";
          };

          "~ ^/lib.*\.(js|css|gif|png|ico|jpg|jpeg)$" = {
            extraConfig = "expires 365d;";
          };

          "/" = {
            priority = 1;
            index = "doku.php";
            extraConfig = ''try_files $uri $uri/ @dokuwiki;'';
          };

          "@dokuwiki" = {
            extraConfig = ''
              # rewrites "doku.php/" out of the URLs if you set the userwrite setting to .htaccess in dokuwiki config page
              rewrite ^/_media/(.*) /lib/exe/fetch.php?media=$1 last;
              rewrite ^/_detail/(.*) /lib/exe/detail.php?media=$1 last;
              rewrite ^/_export/([^/]+)/(.*) /doku.php?do=export_$1&id=$2 last;
              rewrite ^/(.*) /doku.php?id=$1&$args last;
            '';
          };

          "~ \\.php$" = {
            extraConfig = ''
              try_files $uri $uri/ /doku.php;
              include ${config.services.nginx.package}/conf/fastcgi_params;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param REDIRECT_STATUS 200;
              fastcgi_pass unix:${config.services.phpfpm.pools."dokuwiki-${hostName}".socket};
              '';
          };

        };
      }) eachSite;
    };
  })

  (mkIf (cfg.webserver == "caddy") {
    services.caddy = {
      enable = true;
      virtualHosts = mapAttrs' (hostName: cfg: (
        nameValuePair "http://${hostName}" {
          extraConfig = ''
            root * ${pkg hostName cfg}/share/dokuwiki
            file_server

            encode zstd gzip
            php_fastcgi unix/${config.services.phpfpm.pools."dokuwiki-${hostName}".socket}

            @restrict_files {
              path /data/* /conf/* /bin/* /inc/* /vendor/* /install.php
            }

            respond @restrict_files 404

            @allow_media {
              path_regexp path ^/_media/(.*)$
            }
            rewrite @allow_media /lib/exe/fetch.php?media=/{http.regexp.path.1}

            @allow_detail   {
              path /_detail*
            }
            rewrite @allow_detail /lib/exe/detail.php?media={path}

            @allow_export   {
              path /_export*
              path_regexp export /([^/]+)/(.*)
            }
            rewrite @allow_export /doku.php?do=export_{http.regexp.export.1}&id={http.regexp.export.2}

            try_files {path} {path}/ /doku.php?id={path}&{query}
          '';
        }
      )) eachSite;
    };
  })

  ]);

  meta.maintainers = with maintainers; [
    _1000101
    onny
    dandellion
  ];
}
