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

  options = {
    programs.localsend = {
      enable = lib.mkEnableOption "localsend";

      package = lib.mkPackageOption pkgs "localsend" {};

      openFirewall = lib.mkEnableOption "the default ports in the firewall for localsend" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    environment.systemPackages = [ cfg.package ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };

  meta.maintainers = pkgs.localsend.meta.maintainers;
}
