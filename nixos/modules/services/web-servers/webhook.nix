{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.webhook;
  webhook = pkgs.webhook;
  user = cfg.user;
  group = cfg.group;
  settingsFormat = pkgs.formats.json {};
  configFile = settingsFormat.generate "webhook.json" cfg.settings;

in {
  options.services.webhook = {

    enable = mkEnableOption "the webhook service";

    user = mkOption {
      default = "webhook";
      description = "User webhook service runs as. Defaults to <literal>webhook</literal>.";
      type = types.str;
    };

    group = mkOption {
      default = "webhook";
      description = "Group webhook service runs as. Defaults to <literal>webhook</literal>.";
      type = types.str;
    };

    settings = mkOption {
      description = "Webhook service settings.";
      type = settingsFormat.type;
      example = literalExpression ''
        [{
          id = "redeploy-webhook";
          execute-command = "/var/scripts/redeploy.sh";
          command-working-directory = "/var/webhook";
        }]
      '';
    };

    path = mkOption {
      default = [];
      description = "Which packages the service can access";
      example = literalExpression ''
        with pkgs; [ nixFlakes ]
      '';
      type = with types; listOf package;
    };

    extraOptions = mkOption {
      default = [ "-verbose" ];
      description = "Which flags to append to the command";
      example = literalExpression ''
        [ "-debug" "-port" 12345" ]
      '';
      type = with types; listOf str;
    };

  };

  config = mkIf cfg.enable {

    systemd.services.webhook = {
      description = "Webhook service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = cfg.path;
      serviceConfig = {
        Type = "simple";
        User = user;
        Group = group;
        WorkingDirectory = "${webhook}";
        ExecStart = ''
          ${webhook}/bin/webhook -hooks ${configFile} ${lib.concatMapStringsSep " " builtins.toJSON cfg.extraOptions}
        '';
      };
    };

    users = {
      users.webhook = mkIf (cfg.user == "webhook") {
        isSystemUser = true;
        inherit group;
      };
      groups.webhook = mkIf (cfg.group == "webhook") {};
    };

  };

  meta.maintainers = with maintainers; [ ymarkus ];
}
