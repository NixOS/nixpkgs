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
    enable = mkEnableOption "localsend, an open source cross-platform alternative to AirDrop";

    openFirewall = mkOption {
      description = ''
        Whether to open the firewall port ${builtins.toString firewallPort} for receiving files.
      '';
      default = true;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ localsend ];
    networking.firewall.allowedTCPPorts = optional cfg.openFirewall firewallPort;
  };
}
