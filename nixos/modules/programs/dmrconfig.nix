{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.dmrconfig;

in {
  meta.maintainers = [ maintainers.etu ];

  ###### interface
  options = {
    programs.dmrconfig = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to configure system to enable use of dmrconfig. This
          enables the required udev rules and installs the program.
        '';
        relatedPackages = [ "dmrconfig" ];
      };

      package = mkOption {
        default = pkgs.dmrconfig;
        type = types.package;
        defaultText = "pkgs.dmrconfig";
        description = "dmrconfig derivation to use";
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };
}
