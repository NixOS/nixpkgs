{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.proton-vpn;
in
{
  meta.maintainers = [ lib.maintainers.HeitorAugustoLN ];

  options.services.proton-vpn = {
    enable = lib.mkEnableOption "Proton VPN";
    package = lib.mkPackageOption pkgs "protonvpn-gui" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.firewall.checkReversePath = lib.mkDefault false;
    services.proton-vpn-daemon.enable = lib.mkDefault true;
  };
}
