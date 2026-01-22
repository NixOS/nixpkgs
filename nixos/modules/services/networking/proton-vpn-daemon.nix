{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.proton-vpn-daemon;
in
{
  meta.maintainers = [ lib.maintainers.HeitorAugustoLN ];

  options.services.proton-vpn-daemon = {
    enable = lib.mkEnableOption "Proton VPN Daemon";
    package = lib.mkPackageOption pkgs [ "python3Packages" "proton-vpn-daemon" ] { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
  };
}
