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

      package = mkOption {
        default = pkgs.dmrconfig;
        type = types.package;
        defaultText = literalExpression "pkgs.dmrconfig";
        description = lib.mdDoc "dmrconfig derivation to use";
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };
}
