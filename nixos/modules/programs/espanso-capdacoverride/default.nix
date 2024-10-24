{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  meta = {
    maintainers = with maintainers; [ pitkling ];
  };

  options = {
    programs.espanso.capdacoverride = {
      enable = (mkEnableOption "espanso-wayland overlay with DAC_OVERRIDE capability") // {
        default = false;
        extraDescription = ''
          Creates an espanso binary with the DAC_OVERRIDE capability (via `security.wrappers`) and overlays `pkgs.espanso-wayland` such that self-forks call the capability-enabled binary.
          Required for `pkgs.espanso-wayland` to work correctly if not run with root privileges.
        '';
      };

      package = mkOption {
        type = types.package // {
          check = package: types.package.check package && (builtins.elem "wayland" package.buildFeatures);
          description =
            types.package.description
            + " for espanso with wayland support (`package.builtFeatures` must contain `\"wayland\"`)";
        };
        default = pkgs._espanso-wayland-orig;
        defaultText = "pkgs.espanso-wayland (before applying the overlay)";
        description = "The espanso-wayland package used as the base to generate the capability-enabled package.";
      };
    };
  };

  config =
    let
      cfg = config.programs.espanso.capdacoverride;
    in
    mkIf cfg.enable {
      nixpkgs.overlays = [
        (final: prev: {
          _espanso-wayland-orig = prev.espanso-wayland;
          espanso-wayland = pkgs.callPackage ./espanso-capdacoverride.nix {
            capDacOverrideWrapperDir = "${config.security.wrapperDir}";
            espanso = cfg.package;
          };
        })
      ];

      security.wrappers."${pkgs.espanso-wayland.meta.mainProgram}" = {
        source = "${getExe pkgs.espanso-wayland}";
        capabilities = "cap_dac_override+p";
        owner = "root";
        group = "root";
      };
    };
}
