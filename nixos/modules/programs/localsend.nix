{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.localsend;
  firewallPort = 53317;
in {
  options.programs.localsend = {
    enable = mkEnableOption (mdDoc "localsend");

    openFirewall = mkOption {
      description = mdDoc ''
        Whether to open the firewall port ${firewallPort} for receiving files.
      '';
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [localsend];
    networking.firewall.allowedTCPPorts = optional cfg.openFirewall firewallPort;
  };
}
