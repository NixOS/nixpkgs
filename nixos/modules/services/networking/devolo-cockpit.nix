{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.devolo-cockpit;
in
{
  options.services.devolo-cockpit = {
    enable = lib.mkEnableOption "devolo network service daemon for dLAN/Magic powerline adapters";

    package = lib.mkPackageOption pkgs "devolo-cockpit" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.devolonetsvc = {
      description = "devolo network service daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "devolonetsvc";
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ malix ];
}
