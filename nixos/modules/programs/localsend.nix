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

    openFirewall = lib.mkOption {
      description = ''
        Whether to open the firewall port ${toString firewallPort} for receiving files.
      '';
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ localsend ];
    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall firewallPort;
  };
}
