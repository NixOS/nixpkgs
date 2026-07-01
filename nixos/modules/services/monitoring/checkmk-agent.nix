{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.checkmk-agent;
in
{
  options.services.checkmk-agent = {
    enable = lib.mkEnableOption "checkmk agent";
    package = lib.mkPackageOption pkgs "checkmk-agent" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];

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

    users.users.cmk-agent = {
      packages = [ cfg.package ];
      isSystemUser = true;
      home = "/var/lib/check_mk_agent";
      group = "cmk-agent";
    };
    users.groups.cmk-agent = { };

    systemd = {
      services = {
        "check-mk-agent@".enable = true;
        cmk-agent-ctl-daemon = {
          enable = true;
          wantedBy = [ "multi-user.target" ];
        };
      };
      sockets.check-mk-agent = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ weriomat ];
}
