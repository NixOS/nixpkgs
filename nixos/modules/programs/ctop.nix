{ config, lib, pkgs, ... }:

with lib;


let
  cfg = config.programs.ctop;
in

{
  options.programs.ctop = {
    package = mkOption {
      type = types.package;
      default = pkgs.ctop;
      defaultText = "pkgs.ctop";
      description = ''
        The ctop package that should be used.
      '';
    };

    enable = mkEnableOption "ctop";

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
  };

  meta.maintainers = with maintainers; [ Crafter ];

}
