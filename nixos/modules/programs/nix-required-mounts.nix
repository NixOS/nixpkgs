{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nix-required-mounts;
  hook =
    pkgs.nix-required-mounts.override { inherit (cfg) allowedPatterns; };

  patternType = with lib.types; submodule ({ config, name, ... }: {
    options.onFeatures = lib.mkOption {
      type = listOf str;
      description = "Which requiredSystemFeatures should trigger relaxation of the sandbox";
      default = [ name ];
    };
    options.paths = lib.mkOption {
      type = listOf path;
      description = "A list of glob patterns, indicating which paths to expose to the sandbox";
    };
  });

  defaults = {
    opengl.onFeatures = [ "opengl" ];
    opengl.paths = [
      "/dev/video*"
      "/dev/dri"

      pkgs.addOpenGLRunpath.driverLink
      # /run/opengl-driver/lib only contains symlinks
      config.hardware.opengl.package
    ] ++ config.hardware.opengl.extraPackages;
    cuda.onFeatures = [ "cuda" ];
    cuda.paths = defaults.opengl.paths ++ [ "/dev/nvidia*" ];
  };
in
{
  meta.maintainers = with lib.maintainers; [ SomeoneSerge ];
  options.programs.nix-required-mounts = {
    enable = lib.mkEnableOption
      "Expose extra paths to the sandbox depending on derivations' requiredSystemFeatures";
    presets.opengl.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hardware.opengl.enable;
      defaultText = lib.literalExpression "hardware.opengl.enable";
      description = ''
        Expose OpenGL drivers to derivations marked with requiredSystemFeatures = [ "opengl" ]
      '';
    };
    presets.cuda.enable = lib.mkEnableOption ''
      Expose CUDA drivers and GPUs to derivations marked with requiredSystemFeatures = [ "cuda" ]
    '';
    allowedPatterns = with lib.types;
      lib.mkOption rec {
        type = attrsOf patternType;
        description = "The hook config, describing which paths to mount for which system features";
        default = { inherit (defaults) opengl; };
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
        example.require-ipfs = [ "/ipfs" ];
      };
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      nix.settings.pre-build-hook = lib.getExe hook;
    }
    (lib.mkIf cfg.presets.opengl.enable {
      nix.settings.system-features = [ "opengl" ];
      programs.nix-required-mounts.allowedPatterns = {
        inherit (defaults) opengl;
      };
    })
    (lib.mkIf cfg.presets.cuda.enable {
      nix.settings.system-features = [ "cuda" ];
      programs.nix-required-mounts.allowedPatterns = {
        inherit (defaults) cuda;
      };
    })
  ]);
}
