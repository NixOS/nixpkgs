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

    openFirewall =
      lib.mkEnableOption "opening the firewall port ${toString firewallPort} for receiving files"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.localsend ];
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ firewallPort ];
  };

  meta.maintainers = with lib.maintainers; [ pandapip1 ];
}
