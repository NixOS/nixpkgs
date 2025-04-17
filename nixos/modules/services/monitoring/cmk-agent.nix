{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cmk-agent;
in
{
  options.services.cmk-agent = {
    enable = lib.mkEnableOption "checkmk agent";
    package = lib.mkPackageOption pkgs "checkmk-agent" { };
  };

  config = lib.mkIf cfg.enable {
    # import systemd units from package
    systemd.packages = [ cfg.package ];

    # setup dirs for data
    systemd.tmpfiles.settings."10-checkmk" =
      let
        cfg = {
          group = "cmk-agent";
          user = "cmk-agent";
          mode = "700";
        };
      in
      {
        "/var/lib/check_mk_agent".d = cfg;
        "/var/lib/check_mk_agent/spool".d = cfg;
        "/etc/check_mk".d = cfg;
      };

    # create mandatory user
    users.users.cmk-agent = {
      packages = [ cfg.package ];
      isSystemUser = true;
      home = "/var/lib/check_mk_agent";
      group = "cmk-agent";
    };
    users.groups.cmk-agent = { };

    # NOTE: the units still need to be enabled + installed
    systemd = {
      services = {
        # socket activated template
        "check-mk-agent@".enable = true;
        # main cmk-agent-ctl daemon service
        cmk-agent-ctl-daemon = {
          enable = true;
          wantedBy = [ "multi-user.target" ];
        };
      };
      # socket for check-mk-agent@
      sockets.check-mk-agent = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    cobalt
    weriomat
  ];
}
