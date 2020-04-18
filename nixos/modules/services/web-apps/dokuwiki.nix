{ config, lib, pkgs, ... }:

let

  inherit (lib) mkEnableOption mkForce mkIf mkMerge mkOption optionalAttrs recursiveUpdate types;
  inherit (lib) concatMapStringsSep flatten mapAttrs mapAttrs' mapAttrsToList nameValuePair concatMapStringSep;

  eachSite = config.services.dokuwiki;

  user = "dokuwiki";
  group = config.services.nginx.group;

  dokuwikiAclAuthConfig = cfg: pkgs.writeText "acl.auth.php" ''
    # acl.auth.php
    # <?php exit()?>
    #
    # Access Control Lists
    #
    ${toString cfg.acl}
  '';

  dokuwikiLocalConfig = cfg: pkgs.writeText "local.php" ''
    <?php
    $conf['savedir'] = '${cfg.stateDir}';
    $conf['superuser'] = '${toString cfg.superUser}';
    $conf['useacl'] = '${toString cfg.aclUse}';
    $conf['disableactions'] = '${cfg.disableActions}';
    ${toString cfg.extraConfig}
  '';

  dokuwikiPluginsLocalConfig = cfg: pkgs.writeText "plugins.local.php" ''
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
      ln -s ${dokuwikiLocalConfig cfg} $out/share/dokuwiki/local.php

      # symlink plugins config
      ln -s ${dokuwikiPluginsLocalConfig cfg} $out/share/dokuwiki/plugins.local.php

      # symlink acl
      ln -s ${dokuwikiAclAuthConfig cfg} $out/share/dokuwiki/acl.auth.php

      # symlink additional plugin(s) and templates(s)
      ${concatMapStringsSep "\n" (template: "ln -s ${template} $out/share/dokuwiki/lib/tpl/${template.name}") cfg.templates}
      ${concatMapStringsSep "\n" (plugin: "ln -s ${plugin} $out/share/dokuwiki/lib/plugins/${plugin.name}") cfg.plugins}
    '';
  };

  siteOpts = { config, lib, name, ...}: {
    options = {
      enable = mkEnableOption "DokuWiki web application.";

      package = mkOption {
        type = types.package;
        default = pkgs.dokuwiki;
        description = "Which dokuwiki package to use.";
      };

      hostName = mkOption {
        type = types.str;
        default = "localhost";
        description = "FQDN for the instance.";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/dokuwiki/${name}/data";
        description = "Location of the dokuwiki state directory.";
      };

      acl = mkOption {
        type = types.nullOr types.lines;
        default = null;
        example = "*               @ALL               8";
        description = ''
          Access Control Lists: see <link xlink:href="https://www.dokuwiki.org/acl"/>
          Mutually exclusive with services.dokuwiki.aclFile
          Set this to a value other than null to take precedence over aclFile option.

          Warning: Consider using aclFile instead if you do not
          want to store the ACL in the world-readable Nix store.
        '';
      };

      aclFile = mkOption {
        type = with types; nullOr str;
        default = if (config.aclUse && config.acl == null) then "/var/lib/dokuwiki/${name}/users.auth.php" else null;
        description = ''
          Location of the dokuwiki acl rules. Mutually exclusive with services.dokuwiki.acl
          Mutually exclusive with services.dokuwiki.acl which is preferred.
          Consult documentation <link xlink:href="https://www.dokuwiki.org/acl"/> for further instructions.
          Example: <link xlink:href="https://github.com/splitbrain/dokuwiki/blob/master/conf/acl.auth.php.dist"/>
        '';
        example = "/var/lib/dokuwiki/${name}/acl.auth.php";
      };

      aclUse = mkOption {
        type = types.bool;
        default = true;
        description = ''
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
        description = ''
          List of the dokuwiki (un)loaded plugins.
        '';
      };

      superUser = mkOption {
        type = types.nullOr types.str;
        default = "@admin";
        description = ''
          You can set either a username, a list of usernames (“admin1,admin2”),
          or the name of a group by prepending an @ char to the groupname
          Consult documentation <link xlink:href="https://www.dokuwiki.org/config:superuser"/> for further instructions.
        '';
      };

      usersFile = mkOption {
        type = with types; nullOr str;
        default = if config.aclUse then "/var/lib/dokuwiki/${name}/users.auth.php" else null;
        description = ''
          Location of the dokuwiki users file. List of users. Format:
          login:passwordhash:Real Name:email:groups,comma,separated
          Create passwordHash easily by using:$ mkpasswd -5 password `pwgen 8 1`
          Example: <link xlink:href="https://github.com/splitbrain/dokuwiki/blob/master/conf/users.auth.php.dist"/>
          '';
        example = "/var/lib/dokuwiki/${name}/users.auth.php";
      };

      disableActions = mkOption {
        type = types.nullOr types.str;
        default = "";
        example = "search,register";
        description = ''
          Disable individual action modes. Refer to
          <link xlink:href="https://www.dokuwiki.org/config:action_modes"/>
          for details on supported values.
        '';
      };

      extraConfig = mkOption {
        type = types.nullOr types.lines;
        default = null;
        example = ''
          $conf['title'] = 'My Wiki';
          $conf['userewrite'] = 1;
        '';
        description = ''
          DokuWiki configuration. Refer to
          <link xlink:href="https://www.dokuwiki.org/config"/>
          for details on supported values.
        '';
      };

      plugins = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
              List of path(s) to respective plugin(s) which are copied from the 'plugin' directory.
              <note><para>These plugins need to be packaged before use, see example.</para></note>
        '';
        example = ''
              # Let's package the icalevents plugin
              plugin-icalevents = pkgs.stdenv.mkDerivation {
                name = "icalevents";
                # Download the plugin from the dokuwiki site
                src = pkgs.fetchurl {
                  url = https://github.com/real-or-random/dokuwiki-plugin-icalevents/releases/download/2017-06-16/dokuwiki-plugin-icalevents-2017-06-16.zip;
                  sha256 = "e40ed7dd6bbe7fe3363bbbecb4de481d5e42385b5a0f62f6a6ce6bf3a1f9dfa8";
                };
                sourceRoot = ".";
                # We need unzip to build this package
                buildInputs = [ pkgs.unzip ];
                # Installing simply means copying all files to the output directory
                installPhase = "mkdir -p $out; cp -R * $out/";
              };

              # And then pass this theme to the plugin list like this:
              plugins = [ plugin-icalevents ];
        '';
      };

      templates = mkOption {
        type = types.listOf types.path;
        default = [];
        description = ''
              List of path(s) to respective template(s) which are copied from the 'tpl' directory.
              <note><para>These templates need to be packaged before use, see example.</para></note>
        '';
        example = ''
              # Let's package the bootstrap3 theme
              template-bootstrap3 = pkgs.stdenv.mkDerivation {
                name = "bootstrap3";
                # Download the theme from the dokuwiki site
                src = pkgs.fetchurl {
                  url = https://github.com/giterlizzi/dokuwiki-template-bootstrap3/archive/v2019-05-22.zip;
                  sha256 = "4de5ff31d54dd61bbccaf092c9e74c1af3a4c53e07aa59f60457a8f00cfb23a6";
                };
                # We need unzip to build this package
                buildInputs = [ pkgs.unzip ];
                # Installing simply means copying all files to the output directory
                installPhase = "mkdir -p $out; cp -R * $out/";
              };

              # And then pass this theme to the template list like this:
              templates = [ template-bootstrap3 ];
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
        description = ''
          Options for the dokuwiki PHP pool. See the documentation on <literal>php-fpm.conf</literal>
          for details on configuration directives.
        '';
      };

      nginx = mkOption {
        type = types.submodule (
          recursiveUpdate
            (import ../web-servers/nginx/vhost-options.nix { inherit config lib; })
            {
              # Enable encryption by default,
              options.forceSSL.default = true;
              options.enableACME.default = true;
            }
        );
        default = {forceSSL = true; enableACME = true;};
        example = {
          serverAliases = [
            "wiki.\${config.networking.domain}"
          ];
          enableACME = false;
        };
        description = ''
          With this option, you can customize the nginx virtualHost which already has sensible defaults for DokuWiki.
        '';
      };
    };
  };
in
{
  # interface
  options = {
    services.dokuwiki = mkOption {
      type = types.attrsOf (types.submodule siteOpts);
      default = {};
      description = "Sepcification of one or more dokuwiki sites to service.";
    };
  };

  # implementation

  config = mkIf (eachSite != {}) {

    warnings = mapAttrsToList (hostName: cfg: mkIf (cfg.superUser == null) "Not setting services.dokuwiki.${hostName} superUser will impair your ability to administer DokuWiki") eachSite;

    assertions = flatten (mapAttrsToList (hostName: cfg:
    [{
      assertion = cfg.aclUse -> (cfg.acl != null || cfg.aclFile != null);
      message = "Either services.dokuwiki.${hostName}.acl or services.dokuwiki.${hostName}.aclFile is mandatory if aclUse true";
    }
    {
      assertion = cfg.usersFile != null -> cfg.aclUse != false;
      message = "services.dokuwiki.${hostName}.aclUse must must be true if usersFile is not null";
    }
    ]) eachSite);

    services.phpfpm.pools = mapAttrs' (hostName: cfg: (
      nameValuePair "dokuwiki-${hostName}" {
        inherit user;
        inherit group;
        phpEnv = {
          DOKUWIKI_LOCAL_CONFIG = "${dokuwikiLocalConfig cfg}";
          DOKUWIKI_PLUGINS_LOCAL_CONFIG = "${dokuwikiPluginsLocalConfig cfg}";
        } // optionalAttrs (cfg.usersFile != null) {
          DOKUWIKI_USERS_AUTH_CONFIG = "${cfg.usersFile}";
        } //optionalAttrs (cfg.aclUse) {
          DOKUWIKI_ACL_AUTH_CONFIG = if (cfg.acl != null) then "${dokuwikiAclAuthConfig cfg}" else "${toString cfg.aclFile}";
        };

        settings = {
          "listen.mode" = "0660";
          "listen.owner" = user;
          "listen.group" = group;
        } // cfg.poolConfig;
      })) eachSite;

    services.nginx = {
      enable = true;
      virtualHosts = mapAttrs (hostName: cfg:  mkMerge [ cfg.nginx {
        root = mkForce "${pkg hostName cfg}/share/dokuwiki";
        extraConfig = "fastcgi_param HTTPS on;";

        locations."~ /(conf/|bin/|inc/|install.php)" = {
          extraConfig = "deny all;";
        };

        locations."~ ^/data/" = {
          root = "${cfg.stateDir}";
          extraConfig = "internal;";
        };

        locations."~ ^/lib.*\.(js|css|gif|png|ico|jpg|jpeg)$" = {
          extraConfig = "expires 365d;";
        };

        locations."/" = {
          priority = 1;
          index = "doku.php";
          extraConfig = ''try_files $uri $uri/ @dokuwiki;'';
        };

        locations."@dokuwiki" = {
          extraConfig = ''
              # rewrites "doku.php/" out of the URLs if you set the userwrite setting to .htaccess in dokuwiki config page
              rewrite ^/_media/(.*) /lib/exe/fetch.php?media=$1 last;
              rewrite ^/_detail/(.*) /lib/exe/detail.php?media=$1 last;
              rewrite ^/_export/([^/]+)/(.*) /doku.php?do=export_$1&id=$2 last;
              rewrite ^/(.*) /doku.php?id=$1&$args last;
          '';
        };

        locations."~ \.php$" = {
          extraConfig = ''
              try_files $uri $uri/ /doku.php;
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param REDIRECT_STATUS 200;
              fastcgi_pass unix:${config.services.phpfpm.pools."dokuwiki-${hostName}".socket};
              fastcgi_param HTTPS on;
          '';
        };
      }]) eachSite;
    };

    systemd.tmpfiles.rules = flatten (mapAttrsToList (hostName: cfg: [
      "d ${cfg.stateDir}/attic 0750 ${user} ${group} - -"
      "d ${cfg.stateDir}/cache 0750 ${user} ${group} - -"
      "d ${cfg.stateDir}/index 0750 ${user} ${group} - -"
      "d ${cfg.stateDir}/locks 0750 ${user} ${group} - -"
      "d ${cfg.stateDir}/media 0750 ${user} ${group} - -"
      "d ${cfg.stateDir}/media_attic 0750 ${user} ${group} - -"
      "d ${cfg.stateDir}/media_meta 0750 ${user} ${group} - -"
      "d ${cfg.stateDir}/meta 0750 ${user} ${group} - -"
      "d ${cfg.stateDir}/pages 0750 ${user} ${group} - -"
      "d ${cfg.stateDir}/tmp 0750 ${user} ${group} - -"
    ] ++ lib.optional (cfg.aclFile != null) "C ${cfg.aclFile} 0640 ${user} ${group} - ${pkg hostName cfg}/share/dokuwiki/conf/acl.auth.php.dist"
    ++ lib.optional (cfg.usersFile != null) "C ${cfg.usersFile} 0640 ${user} ${group} - ${pkg hostName cfg}/share/dokuwiki/conf/users.auth.php.dist"
    ) eachSite);

    users.users.${user} = {
      group = group;
      isSystemUser = true;
    };
  };
}
