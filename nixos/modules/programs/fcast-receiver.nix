{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.fcast-receiver;
in
{
  meta = {
    maintainers = pkgs.fcast-receiver.meta.maintainers;
  };

  options.programs.fcast-receiver = {
    enable = mkEnableOption (lib.mdDoc "FCast Receiver");
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open ports needed for the functionality of the program.
      '';
    };
    package = mkPackageOption pkgs "fcast-receiver" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 46899 ];
    };
  };
}
