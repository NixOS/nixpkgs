{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.weechat;
in

{
  options.services.weechat = {
    enable = mkEnableOption (lib.mdDoc "weechat");
    root = mkOption {
      description = lib.mdDoc "Weechat state directory.";
      type = types.str;
      default = "/var/lib/weechat";
    };
    sessionName = mkOption {
      description = lib.mdDoc "Name of the `screen' session for weechat.";
      default = "weechat-screen";
      type = types.str;
    };
    binary = mkOption {
      type = types.path;
      description = lib.mdDoc "Binary to execute.";
      default = "${pkgs.weechat}/bin/weechat";
      defaultText = literalExpression ''"''${pkgs.weechat}/bin/weechat"'';
      example = literalExpression ''"''${pkgs.weechat}/bin/weechat-headless"'';
    };
  };

  config = mkIf cfg.enable {
    users = {
      groups.weechat = {};
      users.weechat = {
        createHome = true;
        group = "weechat";
        home = cfg.root;
        isSystemUser = true;
      };
    };

    systemd.services.weechat = {
      environment.WEECHAT_HOME = cfg.root;
      serviceConfig = {
        User = "weechat";
        Group = "weechat";
        RemainAfterExit = "yes";
      };
      script = "exec ${config.security.wrapperDir}/screen -Dm -S ${cfg.sessionName} ${cfg.binary}";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
    };

    security.wrappers.screen =
      { setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.screen}/bin/screen";
      };
  };

  # Don't edit the docbook xml directly, edit the md and generate it using md-to-db.sh
  meta.doc = ./weechat.xml;
}
