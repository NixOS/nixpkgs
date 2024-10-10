{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.localsend;
in
{
  options.programs.localsend = {
    enable = lib.mkEnableOption "localsend, an open source cross-platform alternative to AirDrop";

    openFirewall = lib.mkEnableOption "opening the firewall port for receiving files" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs "localsend" { };

    # Note that as of version v1.15 (October 2024), the port can not be
    # changed. However, this may change in the future.
    port = lib.mkOption {
      type = lib.types.port;
      default = 53317;
      description = "TCP and UDP port used in receive mode for incoming traffic";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.firewall = {
      allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
      allowedUDPPorts = lib.optional cfg.openFirewall cfg.port;
    };
  };

  meta.maintainers = with lib.maintainers; [ pandapip1 ];
}
