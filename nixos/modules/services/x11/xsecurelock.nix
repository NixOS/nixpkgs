{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.xsecurelock;

  # Script for the image screensaver.
  imageSaver = pkgs.writeScriptBin "saver_image" ''
    #!${pkgs.bash}/bin/sh
    
    # Fall back to blanking the screen with the built-in module if we don't
    # have an image file.
    if [[ -z "$XSECURELOCK_IMAGE_FILE" ]]; then
      exec ./saver_blank
    fi
    
    # Otherwise, we draw the image onto the specified window.
    exec ${pkgs.xloadimage}/bin/xloadimage \
      -fullscreen \
      -windowid "$XSCREENSAVER_WINDOW" \
      "$XSECURELOCK_IMAGE_FILE"
  '';

in {

  options = {
    services.xserver.xsecurelock = {
      enable = mkEnableOption "xsecurelock";

      imageSaver = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If enabled, create a screen saver module for xsecurelock that will
          display an image file.
        '';
      };

      extraModules = mkOption  {
        type = with types; listOf path;
        default = [];

        description = ''
          Extra modules to make available to xautolock. Module files must start
          with "auth_" or "saver_" in order for xautolock to run them, though
          files with other names may be referenced.
        '';

        example = literalExample ''
          services.xserver.xsecurelock.extraModules =
            let
              pkg = lib.writeScriptBin "saver_example" '''
                echo "Do something here; falling back to built-in..."
                exec ./saver_blank 
              ''';
            in
              [ "''${pkg}/bin/saver_example" ];
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.xsecurelock;

        description = ''
          The xsecurelock package to use.

          This may be helpful if you wish to customize the package in ways
          other than adding additional modules.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [
      (cfg.package.override {
        extraModules = cfg.extraModules
          ++ optional cfg.imageSaver "${imageSaver}/bin/saver_image";
      })
    ];

  };
}
