{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.dmrconfig;

in {
  meta.maintainers = with maintainers; [ ];

  ###### interface
  options = {
    programs.dmrconfig = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to configure system to enable use of dmrconfig. This
          enables the required udev rules and installs the program.
        '';
        relatedPackages = [ "dmrconfig" ];
      };

      package = mkPackageOption pkgs "dmrconfig" { };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };
}
