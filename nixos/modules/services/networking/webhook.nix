{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.webhook;
  defaultUser = "webhook";

  hookFormat = pkgs.formats.json { };

  hookType = lib.types.submodule (
    { name, ... }:
    {
      freeformType = hookFormat.type;
      options = {
        id = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = ''
            The ID of your hook. This value is used to create the HTTP endpoint (`protocol://yourserver:port/prefix/''${id}`).
          '';
        };
        execute-command = lib.mkOption {
          type = lib.types.str;
          description = "The command that should be executed when the hook is triggered.";
        };
      };
    }
  );

  hookFiles =
    lib.mapAttrsToList (name: hook: hookFormat.generate "webhook-${name}.json" [ hook ]) cfg.hooks
    ++ lib.mapAttrsToList (
      name: hook: pkgs.writeText "webhook-${name}.json.tmpl" "[${hook}]"
    ) cfg.hooksTemplated;

in
{
  options = {
    services.webhook = {
      enable = lib.mkEnableOption ''
        [Webhook](https://github.com/adnanh/webhook), a server written in Go that allows you to create HTTP endpoints (hooks),
        which execute configured commands for any person or service that knows the URL
      '';

      package = lib.mkPackageOption pkgs "webhook" { };
      user = lib.mkOption {
        type = lib.types.str;
        default = defaultUser;
        description = ''
          Webhook will be run under this user.

          If set, you must create this user yourself!
        '';
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = defaultUser;
        description = ''
          Webhook will be run under this group.

          If set, you must create this group yourself!
        '';
      };
      ip = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = ''
          The IP webhook should serve hooks on.

          The default means it can be reached on any interface if `openFirewall = true`.
        '';
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 9000;
        description = "The port webhook should be reachable from.";
      };
      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open the configured port in the firewall for external ingress traffic.
          Preferably the Webhook server is instead put behind a reverse proxy.
        '';
      };
      enableTemplates = lib.mkOption {
        type = lib.types.bool;
        default = cfg.hooksTemplated != { };
        defaultText = lib.literalExpression "hooksTemplated != {}";
        description = ''
          Enable the generated hooks file to be parsed as a Go template.
          See [the documentation](https://github.com/adnanh/webhook/blob/master/docs/Templates.md) for more information.
        '';
      };
      urlPrefix = lib.mkOption {
        type = lib.types.str;
        default = "hooks";
        description = ''
          The URL path prefix to use for served hooks (`protocol://yourserver:port/''${prefix}/hook-id`).
        '';
      };
      hooks = lib.mkOption {
        type = lib.types.attrsOf hookType;
        default = { };
        example = {
          echo = {
            execute-command = "echo";
            response-message = "Webhook is reachable!";
          };
          redeploy-webhook = {
            execute-command = "/var/scripts/redeploy.sh";
            command-working-directory = "/var/webhook";
          };
        };
        description = ''
          The actual configuration of which hooks will be served.

          Read more on the [project homepage] and on the [hook definition] page.
          At least one hook needs to be configured.

          [hook definition]: https://github.com/adnanh/webhook/blob/master/docs/Hook-Definition.md
          [project homepage]: https://github.com/adnanh/webhook#configuration
        '';
      };
      hooksTemplated = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          echo-template = ''
            {
              "id": "echo-template",
              "execute-command": "echo",
              "response-message": "{{ getenv "MESSAGE" }}"
            }
          '';
        };
        description = ''
          Same as {option}`hooks`, but these hooks are specified as literal strings instead of Nix values,
          and hence can include [template syntax](https://github.com/adnanh/webhook/blob/master/docs/Templates.md)
          which might not be representable as JSON.

          Template syntax requires the {option}`enableTemplates` option to be set to `true`, which is
          done by default if this option is set.
        '';
      };
      verbose = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to show verbose output.";
      };
      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "-secure" ];
        description = ''
          These are arguments passed to the webhook command in the systemd service.
          You can find the available arguments and options in the [documentation][parameters].

          [parameters]: https://github.com/adnanh/webhook/blob/master/docs/Webhook-Parameters.md
        '';
      };
      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Extra environment variables passed to webhook.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =
      let
        overlappingHooks = builtins.intersectAttrs cfg.hooks cfg.hooksTemplated;
      in
      [
        {
          assertion = hookFiles != [ ];
          message = "At least one hook needs to be configured for webhook to run.";
        }
        {
          assertion = overlappingHooks == { };
          message = "`services.webhook.hooks` and `services.webhook.hooksTemplated` have overlapping attribute(s): ${lib.concatStringsSep ", " (builtins.attrNames overlappingHooks)}";
        }
      ];

    users.users = lib.mkIf (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
        group = cfg.group;
        description = "Webhook daemon user";
      };
    };

    users.groups = lib.mkIf (cfg.user == defaultUser && cfg.group == defaultUser) {
      ${defaultUser} = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.webhook = {
      description = "Webhook service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = config.networking.proxy.envVars // cfg.environment;
      script =
        let
          args =
            [
              "-ip"
              cfg.ip
              "-port"
              (toString cfg.port)
              "-urlprefix"
              cfg.urlPrefix
            ]
            ++ lib.concatMap (hook: [
              "-hooks"
              hook
            ]) hookFiles
            ++ lib.optional cfg.enableTemplates "-template"
            ++ lib.optional cfg.verbose "-verbose"
            ++ cfg.extraArgs;
        in
        ''
          ${cfg.package}/bin/webhook ${lib.escapeShellArgs args}
        '';
      serviceConfig = {
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
