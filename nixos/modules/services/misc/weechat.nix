{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.weechat;
in

{
  options.services.weechat = {
    enable = lib.mkEnableOption "weechat";
    root = lib.mkOption {
      description = "Weechat state directory.";
      type = lib.types.str;
      default = "/var/lib/weechat";
    };
    sessionName = lib.mkOption {
      description = "Name of the `screen` session for weechat.";
      default = "weechat-screen";
      type = lib.types.str;
    };
    binary = lib.mkOption {
      type = lib.types.path;
      description = "Binary to execute.";
      default = "${pkgs.weechat}/bin/weechat";
      defaultText = lib.literalExpression ''"''${pkgs.weechat}/bin/weechat"'';
      example = lib.literalExpression ''"''${pkgs.weechat}/bin/weechat-headless"'';
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.weechat = { };
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

    security.wrappers.screen = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkgs.screen}/bin/screen";
    };
  };

  meta.doc = ./weechat.md;
}
