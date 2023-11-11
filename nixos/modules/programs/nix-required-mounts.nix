{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nix-required-mounts;
  package = pkgs.nix-required-mounts;
  overridenPackage = package.override { inherit (cfg) allowedPatterns; };

  Pattern = with lib.types;
    submodule ({ config, name, ... }: {
      options.onFeatures = lib.mkOption {
        type = listOf str;
        description =
          "Which requiredSystemFeatures should trigger relaxation of the sandbox";
        default = [ name ];
      };
      options.paths = lib.mkOption {
        type = listOf path;
        description =
          "A list of glob patterns, indicating which paths to expose to the sandbox";
      };
    });

  driverPaths = [
    # symlinks in /run/opengl-driver/lib:
    pkgs.addOpenGLRunpath.driverLink

    # mesa:
    config.hardware.opengl.package

    # nvidia_x11, etc:
  ] ++ config.hardware.opengl.extraPackages; # nvidia_x11

  defaults = {
    nvidia-gpu.onFeatures = package.allowedPatterns.nvidia-gpu.onFeatures;
    nvidia-gpu.paths = package.allowedPatterns.nvidia-gpu.paths ++ driverPaths;
  };
in
{
  meta.maintainers = with lib.maintainers; [ SomeoneSerge ];
  options.programs.nix-required-mounts = {
    enable = lib.mkEnableOption
      "Expose extra paths to the sandbox depending on derivations' requiredSystemFeatures";
    presets.nvidia-gpu.enable = lib.mkEnableOption ''
      Declare the support for derivations that require an Nvidia GPU to be
      available, e.g. derivations with `requiredSystemFeatures = [ "cuda" ]`.
      This mounts the corresponding userspace drivers and device nodes in the
      sandbox, but only for derivations that request these special features.

      You may extend or override the exposed paths via the
      `programs.nix-required-mounts.allowedPatterns.nvidia-gpu.paths` option.
    '';
    allowedPatterns = with lib.types;
      lib.mkOption rec {
        type = attrsOf Pattern;
        description =
          "The hook config, describing which paths to mount for which system features";
        default = { };
        defaultText = lib.literalExpression ''
          {
            opengl.paths = config.hardware.opengl.extraPackages ++ [
              config.hardware.opengl.package
              pkgs.addOpenGLRunpath.driverLink
              "/dev/video*"
              "/dev/dri"
            ];
          }
        '';
        example.require-ipfs.paths = [ "/ipfs" ];
        example.require-ipfs.onFeatures = [ "ifps" ];
      };
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    { nix.settings.pre-build-hook = lib.getExe overridenPackage; }
    (lib.mkIf cfg.presets.nvidia-gpu.enable {
      nix.settings.system-features = cfg.allowedPatterns.nvidia-gpu.onFeatures;
      programs.nix-required-mounts.allowedPatterns = {
        inherit (defaults) nvidia-gpu;
      };
    })
  ]);
}
