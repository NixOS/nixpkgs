{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.espanso.capdacoverride;
in
{
  meta = {
    maintainers = with lib.maintainers; [ pitkling ];
  };

  options = {
    programs.espanso.capdacoverride = {
      enable = (lib.mkEnableOption "espanso-wayland overlay with DAC_OVERRIDE capability") // {
        description = ''
          Creates an espanso binary with the DAC_OVERRIDE capability (via `security.wrappers`) and overlays `pkgs.espanso-wayland` such that self-forks call the capability-enabled binary.
          Required for `pkgs.espanso-wayland` to work correctly if not run with root privileges.
        '';
      };

      package = lib.mkOption {
        type = lib.types.package // {
          check = package: lib.types.package.check package && (builtins.elem "wayland" package.buildFeatures);
          description =
            lib.types.package.description
            + " for espanso with wayland support (`package.builtFeatures` must contain `\"wayland\"`)";
        };
        default = pkgs._espanso-wayland-orig;
        defaultText = "pkgs.espanso-wayland (before applying the overlay)";
        description = "The espanso-wayland package used as the base to generate the capability-enabled package.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        _espanso-wayland-orig = prev.espanso-wayland;
        espanso-wayland = pkgs.callPackage ./espanso-capdacoverride.nix {
          capDacOverrideWrapperDir = "${config.security.wrapperDir}";
          espanso = cfg.package;
        };
      })
    ];

    security.wrappers."espanso-wayland" = {
      source = lib.getExe pkgs.espanso-wayland;
      capabilities = "cap_dac_override+p";
      owner = "root";
      group = "root";
    };
  };
}
