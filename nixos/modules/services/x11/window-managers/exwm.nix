{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.exwm;
  loadScript = pkgs.writeText "emacs-exwm-load" ''
    (require 'exwm)
    ${optionalString cfg.enableDefaultConfig ''
      (require 'exwm-config)
      (exwm-config-default)
    ''}
  '';
  packages = epkgs: cfg.extraPackages epkgs ++ [ epkgs.exwm ];
  exwm-emacs = pkgs.emacsWithPackages packages;
in

{
  options = {
    services.xserver.windowManager.exwm = {
      enable = mkEnableOption "exwm";
      enableDefaultConfig = mkOption {
        default = true;
        example = false;
        type = lib.types.bool;
        description = "Enable an uncustomised exwm configuration.";
      };
      extraPackages = mkOption {
        default = self: [];
        example = literalExample ''
          epkgs: [
            epkgs.emms
            epkgs.magit
            epkgs.proofgeneral
          ]
        '';
        description = ''
          Extra packages available to Emacs. The value must be a
          function which receives the attrset defined in
          <varname>emacsPackages</varname> as the sole argument.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "exwm";
      start = ''
        ${exwm-emacs}/bin/emacs -l ${loadScript}
      '';
    };
    environment.systemPackages = [ exwm-emacs ];
  };
}
