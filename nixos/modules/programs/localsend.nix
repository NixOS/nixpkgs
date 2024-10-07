{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.localsend;
  firewallPort = 53317;
in
{
  options.programs.localsend = {
    enable = lib.mkEnableOption "localsend, an open source cross-platform alternative to AirDrop";

    openFirewall = lib.mkEnableOption "opening the firewall port ${toString firewallPort} for receiving files" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs "localsend" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.firewall = {
      allowedTCPPorts = lib.optional cfg.openFirewall firewallPort;
      allowedUDPPorts = lib.optional cfg.openFirewall firewallPort;
    };
  };

  meta.maintainers = with lib.maintainers; [ pandapip1 ];
}
