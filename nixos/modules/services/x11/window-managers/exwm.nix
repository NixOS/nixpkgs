{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.exwm;
  loadScript = pkgs.writeText "emacs-exwm-load" ''
    ${cfg.loadScript}
  '';
  packages = epkgs: cfg.extraPackages epkgs ++ [ epkgs.exwm ];
  exwm-emacs = pkgs.emacs.pkgs.withPackages packages;
in
{

  imports = [
    (lib.mkRemovedOptionModule [ "services" "xserver" "windowManager" "exwm" "enableDefaultConfig" ]
      "The upstream EXWM project no longer provides a default configuration, instead copy (parts of) exwm-config.el to your local config."
    )
  ];

  options = {
    services.xserver.windowManager.exwm = {
      enable = lib.mkEnableOption "exwm";
      loadScript = lib.mkOption {
        default = "(require 'exwm)";
        type = lib.types.lines;
        example = ''
          (require 'exwm)
          (exwm-enable)
        '';
        description = ''
          Emacs lisp code to be run after loading the user's init
          file.
        '';
      };
      extraPackages = lib.mkOption {
        type = lib.types.functionTo (lib.types.listOf lib.types.package);
        default = epkgs: [ ];
        defaultText = lib.literalExpression "epkgs: []";
        example = lib.literalExpression ''
          epkgs: [
            epkgs.emms
            epkgs.magit
            epkgs.proofgeneral
          ]
        '';
        description = ''
          Extra packages available to Emacs. The value must be a
          function which receives the attrset defined in
          {var}`emacs.pkgs` as the sole argument.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.session = lib.singleton {
      name = "exwm";
      start = ''
        ${exwm-emacs}/bin/emacs -l ${loadScript}
      '';
    };
    environment.systemPackages = [ exwm-emacs ];
  };
}
