{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.services.simplesamlphp;

  format = pkgs.formats.php { finalVariable = "$config"; };

  phpPackage = pkgs.php.withExtensions (
    { enabled
    , all
    }: with all;
    [
      xml
      mbstring
    ]
    ++ enabled
  );

  genSSPConfigForOpts = opts: pkgs.runCommand "simplesamlphp-config" {} ''
    mkdir $out
    cp ${format.generate "config.php" opts.settings} $out/config.php
    cp ${format.generate "authsources.php" opts.authSources} $out/authsources.php
  '';
in
{
  meta = {
    maintainers = with lib.maintainers; [ nhnn ];
  };

  options.services.simplesamlphp = with lib; mkOption {
    type = types.attrsOf (lib.types.submodule ({ config, ...}: {
      options = {
        package = mkPackageOption pkgs "simplesamlphp" { };
        configureNginx = mkOption {
          type = types.bool;
          default = true;
          description = "Configure nginx as a reverse proxy for SimpleSAMLphp.";
        };
        localDomain = mkOption {
          type = types.str;
          description = "The domain serving your SimpleSAMLphp instance. This option modifies only /saml";
        };
        settings = mkOption {
          type = lib.types.submodule {
            freeformType = format.type;
            options = {
              baseurlpath = mkOption {
                type = types.str;
                example = "https://filesender.example.com/saml/";
                description = "URL where SimpleSAMLphp can be reached.";
              };
            };
          };
          default = { };
          description = ''
            Configuration options used by SimpleSAMLphp.
            See [](https://simplesamlphp.org/docs/stable/simplesamlphp-install)
            for available options.
          '';
        };

        authSources = mkOption {
          type = with types; format.type;
          default = { };
          description = ''
            Auth sources options used by SimpleSAMLphp.
          '';
        };

        libDir = mkOption {
          type = types.str;
          readOnly = true;
          description = ''
            Path to the SimpleSAMLphp library directory.
          '';
        };
        configDir = mkOption {
          type = types.str;
          readOnly = true;
          description = ''
            Path to the SimpleSAMLphp config directory.
          '';
        };
      };
      config = {
        libDir = "${config.package}/share/php/simplesamlphp/";
        configDir = "${genSSPConfigForOpts config}";
      };
    }));
    default = {};
    description = "Instances of SimpleSAMLphp. <name> should refer to valid phpfpm instance.";
  };

  config = {
    services.phpfpm.pools = lib.mapAttrs (phpfpmName: opts: {
      phpEnv.SIMPLESAMLPHP_CONFIG_DIR = "${genSSPConfigForOpts opts}";
    }) cfg;

    services.nginx.virtualHosts = lib.mapAttrs' (phpfpmName: opts: let
    in
      lib.nameValuePair opts.localDomain (lib.mkIf opts.configureNginx {
        locations."^~ /saml/" = {
          alias = "${opts.package}/share/php/simplesamlphp/www/";
          extraConfig = ''
              location ~ ^(?<prefix>/saml)(?<phpfile>.+?\.php)(?<pathinfo>/.*)?$ {
                include ${pkgs.nginx}/conf/fastcgi.conf;
                fastcgi_split_path_info  ^(.+\.php)(/.+)$;
                fastcgi_pass  unix:${config.services.phpfpm.pools.${phpfpmName}.socket};
                fastcgi_intercept_errors on;
                fastcgi_param SCRIPT_FILENAME $document_root$phpfile;
                fastcgi_param SCRIPT_NAME /saml$phpfile;
                fastcgi_param PATH_INFO $pathinfo if_not_empty;
            }
          '';
          };
      })
    ) cfg;
  };
}
