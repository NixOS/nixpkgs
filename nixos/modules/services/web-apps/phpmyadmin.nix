{ config, lib, pkgs, ... }:

# heavily inspired by nixos/modules/services/web-apps/wordpress.nix

let
  inherit (lib) mkDefault mkEnableOption mkForce mkIf mkMerge mkOption types;
  inherit (lib) any attrValues concatMapStringsSep flatten literalExample;
  inherit (lib) mapAttrs mapAttrs' mapAttrsToList nameValuePair optional optionalAttrs optionalString;

  eachInstance = config.services.phpmyadmin;
  user = "phpmyadmin";
  group = config.services.httpd.group;
  stateDir = hostName: "/var/lib/phpmyadmin/${hostName}";

  phpmyadminConfig = hostName: cfg: pkgs.writeText "config.inc-${hostName}.php" ''
    <?php
      require_once('${stateDir hostName}/blowfish_secret.php');

      $cfg['TempDir'] = '/tmp';

      ${cfg.extraConfig}
    ?>
  '';

  secretsScript = hostStateDir: ''
    if ! test -e "${hostStateDir}/blowfish_secret.php"; then
      umask 0177
      echo "<?php" >> "${hostStateDir}/blowfish_secret.php"
      echo "\$cfg['blowfish_secret'] = '`tr -dc a-zA-Z0-9 </dev/urandom | head -c 64`';" >> "${hostStateDir}/blowfish_secret.php"
      echo "?>" >> "${hostStateDir}/blowfish_secret.php"
      chmod 440 "${hostStateDir}/blowfish_secret.php"
    fi
  '';

  instanceOpts = { lib, name, ... }:
    {
      options = {
        package = mkOption {
          default = pkgs.phpmyadmin;
          type = types.package;
          description = "
            phpmyadmin package to use.
          ";
        };

        virtualHost = mkOption {
          type = types.submodule (import ../web-servers/apache-httpd/vhost-options.nix);
          example = literalExample ''
            {
              hostName = "www.example.org";
              adminAddr = "webmaster@example.org";
              forceSSL = true;
              enableACME = true;
            }
          '';
          description = ''
            Apache configuration can be done by adapting <option>services.httpd.virtualHosts</option>.
          '';
        };

        poolConfig = mkOption {
          type = with types; attrsOf (oneOf [ str int bool ]);
          default = {
            "pm" = "dynamic";
            "pm.max_children" = 5;
            "pm.start_servers" = 1;
            "pm.min_spare_servers" = 1;
            "pm.max_spare_servers" = 2;
            "pm.max_requests" = 500;
          };
          description = ''
            Options for the phpmyadmin PHP pool. See the documentation on <literal>php-fpm.conf</literal>
            for details on configuration directives.
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Any additional text to be appended to the config.inc.php
            configuration file. This is a PHP script. For configuration
            settings, see <link xlink:href='https://docs.phpmyadmin.net/en/latest/config.html'/>.
          '';
        };

        extraHttpdConfig = mkOption {
          type = types.lines;
          default = "";
          example = literalExample ''
            AuthType Basic
            AuthName "Restricted Content"
            AuthUserFile /etc/nixos/.htpasswd
            Require valid-user
          '';
          description = "Any additional text to be appended to the httpd directory config.";
        };
      };

      config.virtualHost.hostName = mkDefault name;
    };
in
{
  # interface
  options = {
    services.phpmyadmin = mkOption {
      type = types.attrsOf (types.submodule instanceOpts);
      default = {};
      description = "Specification of one or more phpmyadmin instances to serve via Apache. You still need to create a mysql user with a password to access the database using the web-interface.";
    };
  };

  # implementation
  config = mkIf (eachInstance != {}) {

    services.phpfpm.pools = mapAttrs' (hostName: cfg: (
      nameValuePair "phpmyadmin-${hostName}" {
        inherit user group;
        phpEnv.PHPMYADMIN_CONFIG = "${phpmyadminConfig hostName cfg}";
        settings = {
          "listen.owner" = config.services.httpd.user;
          "listen.group" = config.services.httpd.group;
        } // cfg.poolConfig;
      }
    )) eachInstance;

    services.httpd = {
      enable = true;
      extraModules = [ "proxy_fcgi" ];
      virtualHosts = mapAttrs (hostName: cfg: mkMerge [ cfg.virtualHost {
        documentRoot = mkForce "${cfg.package}";
        extraConfig = ''
            <Directory "${cfg.package}">
              <FilesMatch "\.php$">
                <If "-f %{REQUEST_FILENAME}">
                  SetHandler "proxy:unix:${config.services.phpfpm.pools."phpmyadmin-${hostName}".socket}|fcgi://localhost/"
                </If>
              </FilesMatch>
              DirectoryIndex index.php
              ${cfg.extraHttpdConfig}
            </Directory>
        '';
      } ]) eachInstance;
    };

    systemd.tmpfiles.rules = flatten (mapAttrsToList (hostName: cfg: [
      "d '${stateDir hostName}' 0750 ${user} ${group} - -"
    ]) eachInstance);

    systemd.services = mkMerge [
      (mapAttrs' (hostName: cfg: (
        nameValuePair "phpmyadmin-init-${hostName}" {
          wantedBy = [ "multi-user.target" ];
          before = [ "phpfpm-phpmyadmin-${hostName}.service" ];
          script = secretsScript (stateDir hostName);

          serviceConfig = {
            Type = "oneshot";
            User = user;
            Group = group;
          };
      })) eachInstance)
    ];

    users.users.${user} = {
      group = group;
      isSystemUser = true;
    };
  };
}
