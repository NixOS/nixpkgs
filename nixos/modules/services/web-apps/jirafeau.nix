{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.jirafeau;

  group = config.services.nginx.group;
  user = config.services.nginx.user;

  withTrailingSlash = str: if hasSuffix "/" str then str else "${str}/";

  localConfig = pkgs.writeText "config.local.php" ''
    <?php
      $cfg['admin_password'] = '${cfg.adminPasswordSha256}';
      $cfg['web_root'] = 'http://${withTrailingSlash cfg.hostName}';
      $cfg['var_root'] = '${withTrailingSlash cfg.dataDir}';
      $cfg['maximal_upload_size'] = ${builtins.toString cfg.maxUploadSizeMegabytes};
      $cfg['installation_done'] = true;

      ${cfg.extraConfig}
  '';
in
{
  options.services.jirafeau = {
    adminPasswordSha256 = mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        SHA-256 of the desired administration password. Leave blank/unset for no password.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/jirafeau/data/";
      description = lib.mdDoc "Location of Jirafeau storage directory.";
    };

    enable = mkEnableOption (lib.mdDoc "Jirafeau file upload application.");

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        $cfg['style'] = 'courgette';
        $cfg['organisation'] = 'ACME';
      '';
      description =  let
        documentationLink =
          "https://gitlab.com/mojo42/Jirafeau/-/blob/${cfg.package.version}/lib/config.original.php";
      in
        lib.mdDoc ''
          Jirefeau configuration. Refer to <${documentationLink}> for supported
          values.
        '';
    };

    hostName = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc "URL of instance. Must have trailing slash.";
    };

    maxUploadSizeMegabytes = mkOption {
      type = types.int;
      default = 0;
      description = lib.mdDoc "Maximum upload size of accepted files.";
    };

    maxUploadTimeout = mkOption {
      type = types.str;
      default = "30m";
      description = let
        nginxCoreDocumentation = "http://nginx.org/en/docs/http/ngx_http_core_module.html";
      in
        lib.mdDoc ''
          Timeout for reading client request bodies and headers. Refer to
          <${nginxCoreDocumentation}#client_body_timeout> and
          <${nginxCoreDocumentation}#client_header_timeout> for accepted values.
        '';
    };

    nginxConfig = mkOption {
      type = types.submodule
        (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
      default = {};
      example = literalExpression ''
        {
          serverAliases = [ "wiki.''${config.networking.domain}" ];
        }
      '';
      description = lib.mdDoc "Extra configuration for the nginx virtual host of Jirafeau.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.jirafeau;
      defaultText = literalExpression "pkgs.jirafeau";
      description = lib.mdDoc "Jirafeau package to use";
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
        Options for Jirafeau PHP pool. See documentation on `php-fpm.conf` for
        details on configuration directives.
      '';
    };
  };


  config = mkIf cfg.enable {
    services = {
      nginx = {
        enable = true;
        virtualHosts."${cfg.hostName}" = mkMerge [
          cfg.nginxConfig
          {
            extraConfig = let
              clientMaxBodySize =
                if cfg.maxUploadSizeMegabytes == 0 then "0" else "${cfg.maxUploadSizeMegabytes}m";
            in
              ''
                index index.php;
                client_max_body_size ${clientMaxBodySize};
                client_body_timeout ${cfg.maxUploadTimeout};
                client_header_timeout ${cfg.maxUploadTimeout};
              '';
            locations = {
              "~ \\.php$".extraConfig = ''
                include ${config.services.nginx.package}/conf/fastcgi_params;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_index index.php;
                fastcgi_pass unix:${config.services.phpfpm.pools.jirafeau.socket};
                fastcgi_param PATH_INFO $fastcgi_path_info;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              '';
            };
            root = mkForce "${cfg.package}";
          }
        ];
      };

      phpfpm.pools.jirafeau = {
        inherit group user;
        phpEnv."JIRAFEAU_CONFIG" = "${localConfig}";
        settings = {
          "listen.mode" = "0660";
          "listen.owner" = user;
          "listen.group" = group;
        } // cfg.poolConfig;
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/files/ 0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/links/ 0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/async/ 0750 ${user} ${group} - -"
    ];
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
