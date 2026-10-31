{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fprintd;

  fprintdPkg = if cfg.tod.enable then pkgs.fprintd-tod else pkgs.fprintd;

  # Overlay to support elanmoc2 if enabled
  myOverlay = final: prev: {
    libfprint = prev.libfprint.overrideAttrs (old: {
      src = builtins.fetchGit {
        url = "https://gitlab.freedesktop.org/depau/libfprint.git";
        ref = "elanmoc2";
        rev = "f4439ce96b2938fea8d4f42223d7faea05bd4048";
      };
    });
    fprintd = prev.fprintd.overrideAttrs (old: {
      mesonCheckFlags = [
        "--no-suite" "fprintd:TestPamFprintd"
        "--no-suite" "fprintd:FPrintdManagerPreStartTests"
      ];
    });
  };

in

{
  ###### interface

  options = {

    services.fprintd = {

      enable = lib.mkEnableOption "fprintd daemon and PAM module for fingerprint readers handling";

      enablePam = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        defaultText = lib.literalExpression "config.services.fprintd.enable";
        description = ''
          When enabled, PAM services will be configured to use fprintd for authorization.

          :::{.note}
          Enabling this option will add fingerprint-based authorization to all
          PAM services, including those which can authorize users in the background.
          If this is undesired, you can override this setting on a per-service
          basis through `config.security.pam.services.<name>.fprintAuth`.
          See https://github.com/NixOS/nixpkgs/issues/442117
          :::
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = fprintdPkg;
        defaultText = lib.literalExpression "if config.services.fprintd.tod.enable then pkgs.fprintd-tod else pkgs.fprintd";
        description = ''
          fprintd package to use.
        '';
      };

      tod = {

        enable = lib.mkEnableOption "Touch OEM Drivers library support";

        driver = lib.mkOption {
          type = lib.types.package;
          example = lib.literalExpression "pkgs.libfprint-2-tod1-goodix";
          description = ''
            Touch OEM Drivers (TOD) package to use.
          '';
        };
      };

      elanmoc2 = {

        enable = lib.mkEnableOption "Compile elanmoc2 to enable support for 04f3:0c00 fingerprint reader";

      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.enablePam -> cfg.enable;
        message = "fprintd.enablePam depends on fprintd.enable";
      }
    ];

    services.dbus.packages = [ cfg.package ];

    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.fprintd.environment = lib.mkIf cfg.tod.enable {
      FP_TOD_DRIVERS_DIR = "${cfg.tod.driver}${cfg.tod.driver.driverPath}";
    };

    # Apply overlay if elanmoc2 is enabled
    nixpkgs.overlays = lib.mkIf cfg.elanmoc2.enable [ myOverlay ];

  };
}
