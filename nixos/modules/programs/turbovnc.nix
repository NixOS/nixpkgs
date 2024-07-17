# Global configuration for the SSH client.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.turbovnc;
in
{
  options = {

    programs.turbovnc = {

      ensureHeadlessSoftwareOpenGL = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to set up NixOS such that TurboVNC's built-in software OpenGL
          implementation works.

          This will enable {option}`hardware.opengl.enable` so that OpenGL
          programs can find Mesa's llvmpipe drivers.

          Setting this option to `false` does not mean that software
          OpenGL won't work; it may still work depending on your system
          configuration.

          This option is also intended to generate warnings if you are using some
          configuration that's incompatible with using headless software OpenGL
          in TurboVNC.
        '';
      };

    };

  };

  config = lib.mkIf cfg.ensureHeadlessSoftwareOpenGL {

    # TurboVNC has builtin support for Mesa llvmpipe's `swrast`
    # software rendering to implement GLX (OpenGL on Xorg).
    # However, just building TurboVNC with support for that is not enough
    # (it only takes care of the X server side part of OpenGL);
    # the indiviudual applications (e.g. `glxgears`) also need to directly load
    # the OpenGL libs.
    # Thus, this creates `/run/opengl-driver` populated by Mesa so that the applications
    # can find the llvmpipe `swrast.so` software rendering DRI lib via `libglvnd`.
    # This comment exists to explain why `hardware.` is involved,
    # even though 100% software rendering is used.
    hardware.opengl.enable = true;

  };
}
