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

    package = lib.mkPackageOption pkgs "weechat" { };

    root = lib.mkOption {
      description = "Weechat state directory.";
      type = lib.types.path;
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
      default = "${cfg.package}/bin/weechat";
      defaultText = lib.literalExpression ''"''${cfg.package}/bin/weechat"'';
      example = lib.literalExpression ''"''${cfg.package}/bin/weechat-headless"'';
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.weechat = { };
      users.weechat = {
        group = "weechat";
        isSystemUser = true;
      };
    };

    systemd.tmpfiles.settings."weechat" = {
      "${cfg.root}" = lib.mkIf (cfg.root != "/var/lib/weechat") {
        d = {
          user = "weechat";
          group = "weechat";
          mode = "750";
        };
      };
    };

    systemd.services.weechat = {
      serviceConfig = {
        User = "weechat";
        Group = "weechat";
        StateDirectory = lib.mkIf (cfg.root == "/var/lib/weechat") "weechat";
        StateDirectoryMode = 750;
        RemainAfterExit = "yes";
      };
      script = "exec ${config.security.wrapperDir}/screen -Dm -S ${cfg.sessionName} ${cfg.binary} --dir ${cfg.root}";
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
