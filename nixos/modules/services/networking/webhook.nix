{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.webhook;
  defaultUser = "webhook";

  hooks-file = pkgs.writeText "webhook-config" (
    builtins.toJSON (
      builtins.attrValues cfg.hooks
    )
  );

  # Todo: more expressive type?
  typeTriggerRule = types.attrs;
  
in {
  options = {
    services.webhook = {
      enable = mkEnableOption "Webhook is a lightweight configurable tool written in Go, that allows you to easily create HTTP endpoints (hooks) on your server, which you can use to execute configured commands.";
      
      package = mkOption {
        type = types.package;
        default = pkgs.webhook;
        defaultText = "pkgs.webhook";
        example = literalExample "pkgs.webhook";
        description = ''
          Webhook package to use.
        '';
      };
      user = mkOption {
        type = types.str;
        default = defaultUser;
        description = ''
          Webhook will be run under this user (user will be created if it doesn't exist. This can be your user name).
        '';
      };
      group = mkOption {
        type = types.str;
        default = defaultUser;
        description = ''
          Webhook will be run under this group (group will be created if it doesn't exist. This can be your group name).
        '';
      };
      hotreload = mkOption {
        type = types.bool;
        default = false;
        description = "Watch hooks file for changes and reload them automatically";
      };
      ip = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "ip the webhook should serve hooks on";
      };
      port = mkOption {
        type = types.port;
        default = 9000;
        description = "port the webhook should serve hooks on";
      };
      template = mkOption {
        type = types.bool;
        default = false;
        description = "parse hooks file as a Go template";
      };
      urlprefix = mkOption {
        type = types.str;
        default = "hooks";
        description = "url prefix to use for served hooks (protocol://yourserver:port/PREFIX/:hook-id)";
      };
      hooks = mkOption {
        default = {};
        description = "Hooks the webhook should serve";
        example = {
          redeploy-webhook = {
            id = "redeploy-webhook";
            execute-command = "/var/scripts/redeploy.sh";
            command-working-directory = "/var/webhook";
          };
        };
        type = types.attrsOf (types.submodule ({ config, ... }: {
          options = {
            id = mkOption {
              type = types.str;
              default = config._module.args.name;
              description = "specifies the ID of your hook. This value is used to create the HTTP endpoint (http://yourserver:port/hooks/your-hook-id)";
            };
            execute-command = mkOption {
              type = types.str;
              description = "specifies the command that should be executed when the hook is triggered";
            };
            command-working-directory = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "specifies the working directory that will be used for the script when it's executed";
            };
            response-message = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "specifies the string that will be returned to the hook initiator";
            };
            response-headers = mkOption {
              type = types.nullOr (types.listOf
                (types.submodule {
                  options = {
                    name = mkOption {
                      type = types.str;
                      example = "X-Example-Header";
                      description = "Header name";
                    };
                    value = mkOption {
                      type = types.str;
                      example = "it works";
                      description = "Header value";
                    };
                  };
                })
              );
              default = null;
              description = "specifies the list of headers that will be returned in HTTP response for the hook";
            };
          };
        }));
      };
      
      success-http-response-code = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        description = "specifies the HTTP status code to be returned upon success";
      };

      
      trigger-rule = mkOption {
        type = types.nullOr typeTriggerRule;
        default = null;
        description = "specifies the list of headers that will be returned in HTTP response for the hook";
      };

      # TODO: add other options from https://github.com/adnanh/webhook/blob/master/docs/Hook-Definition.md
    };
  };
  
  imports = [];
  
  config = mkIf cfg.enable {

    systemd.packages = [ pkgs.webhook ];

    users.users = mkIf (cfg.user == defaultUser) {
      ${defaultUser} =
        { group = cfg.group;
          description = "Webhook daemon user";
        };
    };

    users.groups = mkIf (cfg.group == defaultUser) {
      ${defaultUser} = {};
    };

    systemd.services = {
      webhook = {
        description = "Webhook service";
        after = [ "network.target" ];
        environment = {
          STNORESTART = "yes";
          STNOUPGRADE = "yes";
          inherit (cfg);
        } // config.networking.proxy.envVars;
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "on-failure";
          SuccessExitStatus = "2 3 4";
          RestartForceExitStatus="3 4";
          User = cfg.user;
          Group = cfg.group;
          ExecStart = ''
            ${cfg.package}/bin/webhook \
              -hooks ${hooks-file} \
              ${if cfg.hotreload then "-hotreload" else ""} \
              ${if cfg.template then "-template" else ""} \
              -ip ${cfg.ip} \
              -port ${toString cfg.port} \
              -urlprefix ${cfg.urlprefix}
          # '';
        };
      };
    };
  };  
}
