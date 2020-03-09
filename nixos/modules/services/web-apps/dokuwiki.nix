{ config, lib, pkgs, ... }:

let

  inherit (lib) mkEnableOption mkForce mkIf mkMerge mkOption optionalAttrs recursiveUpdate types;

  cfg = config.services.dokuwiki;

  user = config.services.nginx.user;
  group = config.services.nginx.group;

  dokuwikiAclAuthConfig = pkgs.writeText "acl.auth.php" ''
    # acl.auth.php
    # <?php exit()?>
    #
    # Access Control Lists
    #
    ${toString cfg.acl}
  '';

  dokuwikiLocalConfig = pkgs.writeText "local.php" ''
    <?php
    $conf['savedir'] = '${cfg.stateDir}';
    $conf['superuser'] = '${toString cfg.superUser}';
    $conf['useacl'] = '${toString cfg.aclUse}';
    ${toString cfg.extraConfig}
  '';

  dokuwikiPluginsLocalConfig = pkgs.writeText "plugins.local.php" ''
    <?php
    ${cfg.pluginsConfig}
  '';

in
{
  options.services.dokuwiki = {
    enable = mkEnableOption "DokuWiki web application.";

    hostName = mkOption {
      type = types.str;
      default = "localhost";
      description = "FQDN for the instance.";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/dokuwiki/data";
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
      '';
    };

    aclFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Location of the dokuwiki acl rules. Mutually exclusive with services.dokuwiki.acl
        Mutually exclusive with services.dokuwiki.acl which is preferred.
        Consult documentation <link xlink:href="https://www.dokuwiki.org/acl"/> for further instructions.
        Example: <link xlink:href="https://github.com/splitbrain/dokuwiki/blob/master/conf/acl.auth.php.dist"/>
      '';
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
      type = types.nullOr types.path;
      default = null;
      description = ''
        Location of the dokuwiki users file. List of users. Format:
        login:passwordhash:Real Name:email:groups,comma,separated 
        Create passwordHash easily by using:$ mkpasswd -5 password `pwgen 8 1`
        Example: <link xlink:href="https://github.com/splitbrain/dokuwiki/blob/master/conf/users.auth.php.dist"/>
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

  # implementation

  config = mkIf cfg.enable {

    warnings = mkIf (cfg.superUser == null) ["Not setting services.dokuwiki.superUser will impair your ability to administer DokuWiki"];

    assertions = [ 
      {
        assertion = cfg.aclUse -> (cfg.acl != null || cfg.aclFile != null);
        message = "Either services.dokuwiki.acl or services.dokuwiki.aclFile is mandatory when aclUse is true";
      }
      {
        assertion = cfg.usersFile != null -> cfg.aclUse != false;
        message = "services.dokuwiki.aclUse must be true when usersFile is not null";
      }
    ];

    services.phpfpm.pools.dokuwiki = {
      inherit user;
      inherit group;
      phpEnv = {        
        DOKUWIKI_LOCAL_CONFIG = "${dokuwikiLocalConfig}";
        DOKUWIKI_PLUGINS_LOCAL_CONFIG = "${dokuwikiPluginsLocalConfig}";
      } //optionalAttrs (cfg.usersFile != null) {
        DOKUWIKI_USERS_AUTH_CONFIG = "${cfg.usersFile}";
      } //optionalAttrs (cfg.aclUse) {
        DOKUWIKI_ACL_AUTH_CONFIG = if (cfg.acl != null) then "${dokuwikiAclAuthConfig}" else "${toString cfg.aclFile}";
      };
      
      settings = {
        "listen.mode" = "0660";
        "listen.owner" = user;
        "listen.group" = group;
      } // cfg.poolConfig;
    };

    services.nginx = {
      enable = true;
      
       virtualHosts = {
        ${cfg.hostName} = mkMerge [ cfg.nginx {
          root = mkForce "${pkgs.dokuwiki}/share/dokuwiki/";
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
              fastcgi_pass unix:${config.services.phpfpm.pools.dokuwiki.socket};
              fastcgi_param HTTPS on;
            '';
          };
        }];
      };

    };

    systemd.tmpfiles.rules = [
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
    ];

  };
}
