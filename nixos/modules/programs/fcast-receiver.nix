{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.fcast-receiver;
in
{
  meta = {
    maintainers = pkgs.fcast-receiver.meta.maintainers;
  };

  options.programs.fcast-receiver = {
    enable = lib.mkEnableOption "FCast Receiver";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open ports needed for the functionality of the program.
      '';
    };
    package = lib.mkPackageOption pkgs "fcast-receiver" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 46899 ];
    };
  };
}
