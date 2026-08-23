{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.feishin;
in
{
  options.services.feishin = {
    enable = lib.mkEnableOption "the web version of Feishin";

    package = lib.mkPackageOption pkgs "feishin-web" { };

    domain = lib.mkOption {
      description = "Domain to use for the virtualhost.";
      type = lib.types.str;
    };

    pathbase = lib.mkOption {
      description = "URL path base to use for the virtualhost.";
      type = lib.types.str;
      default = "";
      example = "/music";
    };

    settings = lib.mkOption {
      description = ''
        Configuration for the web version of Feishin, specified as key-value pairs.

        Refer to <https://github.com/jeffvli/feishin#configuration>, and
        <https://github.com/jeffvli/feishin/blob/development/settings.js.template>
        for the template.
      '';
      type = lib.types.attrsOf lib.types.str;
      default = {
        ANALYTICS_DISABLED = "true";
      };
      example = {
        ANALYTICS_DISABLED = "true";
        SERVER_NAME = "My Server";
        SERVER_LOCK = "true";
      };
    };

    nginx = {
      enable = lib.mkEnableOption "a virtualhost to serve Feishin through nginx";

      virtualHost = lib.mkOption {
        description = "Extra configuration for the nginx virtualhost for Feishin.";
        type = lib.types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
        default = { };
        example = lib.literalExpression ''
          {
            serverAliases = [ "feishin.''${config.networking.domain}" ];
          }
        '';
      };
    };

    caddy = {
      enable = lib.mkEnableOption "a virtualhost to serve Feishin through Caddy";

      virtualHost = lib.mkOption {
        description = "Extra configuration for the Caddy virtualhost for Feishin.";
        type = lib.types.submodule (
          import ../web-servers/caddy/vhost-options.nix { cfg = config.services.caddy; }
        );
        default = { };
        example = lib.literalExpression ''
          {
            serverAliases = [ "feishin.''${config.networking.domain}" ];
          }
        '';
      };
    };
  };

  config =
    let
      resolvedSettings =
        cfg.settings // lib.optionalAttrs (cfg.pathbase != "") { PUBLIC_PATH = cfg.pathbase; };
      settingsJs = ''
        "use strict";
        ${lib.concatMapAttrsStringSep "\n" (name: value: ''window.${name} = "${value}";'') resolvedSettings}
      '';
      settingsJsDir = pkgs.writeTextDir "settings.js" settingsJs;
    in
    lib.mkIf cfg.enable {
      services.nginx = lib.mkIf cfg.nginx.enable {
        enable = lib.mkDefault true;
        virtualHosts."${cfg.domain}" = lib.mkMerge [
          cfg.nginx.virtualHost
          {
            root = lib.mkForce "${cfg.package}";
            extraConfig = ''
              gzip on;
              gzip_vary    on;
              gzip_proxied any;
              gzip_types   text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript;
            '';
            locations."${cfg.pathbase}/" = {
              tryFiles = "$uri $uri/ /index.html =404";
            };
            locations."=${cfg.pathbase}/settings.js" = {
              alias = settingsJsDir + "/settings.js";
              extraConfig = ''
                add_header Cache-Control "no-store";
              '';
            };
          }
        ];
      };

      services.caddy = lib.mkIf cfg.caddy.enable {
        enable = lib.mkDefault true;
        virtualHosts."${cfg.domain}" = lib.mkMerge [
          cfg.caddy.virtualHost
          {
            hostName = lib.mkForce cfg.domain;
            extraConfig =
              let
                baseConfig = ''
                  encode
                  handle /settings.js {
                    header Cache-Control no-store
                    root ${settingsJsDir}
                    file_server
                  }
                  handle {
                    root ${cfg.package}
                    try_files {path} /index.html
                    file_server
                  }
                '';
              in
              if (cfg.pathbase == "") then
                baseConfig
              else
                ''
                  handle_path ${cfg.pathbase}/* {
                    ${baseConfig}
                  }
                '';
          }
        ];
      };
    };

  meta.maintainers = with lib.maintainers; [
    rharish
    BatteredBunny
  ];
}
