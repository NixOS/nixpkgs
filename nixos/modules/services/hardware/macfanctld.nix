{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.macfanctld;
in
{
  options.services.macfanctld = {
    enable = lib.mkEnableOption "Fan control for MacBook";
    package = lib.mkPackageOption pkgs "macfanctld" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.macfanctld = {
      description = "Fan control for Macbook";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -f";
        Restart = "on-failure";
      };
    };
  };
}
