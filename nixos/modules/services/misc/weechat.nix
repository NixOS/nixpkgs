{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.weechat;
in

{
  options.services.weechat = {
    enable = mkEnableOption "weechat";
    init = mkOption {
      description = "Weechat commands applied at start, one command per line.";
      example = ''
        /set relay.network.password correct-horse-battery-staple
        /relay add weechat 9001
      '';
      type = types.str;
      default = "";
    };
    root = mkOption {
      description = "Weechat state directory.";
      type = types.str;
      default = "/var/lib/weechat";
    };
  };

  config = mkIf cfg.enable {
    users = {
      users.weechat = {
        createHome = true;
        group = "weechat";
        home = cfg.root;
      };
    };

    systemd.services.weechat = {
      environment.WEECHAT_HOME = cfg.root;
      serviceConfig = {
        User = "weechat";
        Group = "weechat";
      };
      script = "exec ${pkgs.screen}/bin/screen -D -m ${pkgs.weechat}/bin/weechat";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
    };

    systemd.paths.weechat-fifo = {
      pathConfig = {
        PathExists = "${cfg.root}/weechat_fifo";
        Unit = "weechat-apply-init.service";
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.weechat-apply-init = let
      initFile = pkgs.writeText "weechat-init" cfg.init;
    in {
      script = "sed 's/^/*/' ${initFile} > ${cfg.root}/weechat_fifo";
      serviceConfig = {
        Type = "oneshot";
        User = "weechat";
        Group = "weechat";
      };
    };
  };
}
