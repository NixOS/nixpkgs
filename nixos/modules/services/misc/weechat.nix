{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.weechat;
in

{
  options.services.weechat = {
    enable = mkEnableOption "weechat";
    root = mkOption {
      description = "Weechat state directory.";
      type = types.str;
      default = "/var/lib/weechat";
    };
    sessionName = mkOption {
      description = "Name of the `screen' session for weechat.";
      default = "weechat-screen";
      type = types.str;
    };
    binary = mkOption {
      description = "Binary to execute (by default \${weechat}/bin/weechat).";
      example = literalExample ''
        ''${pkgs.weechat}/bin/weechat-headless
      '';
      default = "${pkgs.weechat}/bin/weechat";
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
      script = "exec ${pkgs.screen}/bin/screen -Dm -S ${cfg.sessionName} ${cfg.binary}";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
    };
  };

  meta.doc = ./weechat.xml;
}
