{
  glfw3,
  fetchFromGitHub,
}:
glfw3.overrideAttrs (
  finalAttrs: prevAttrs: {
    pname = "glfw-minecraft";
    version = "3.5.1-unstable-2026-08-06";

    src = fetchFromGitHub {
      owner = "LWJGL-CI";
      repo = "GLFW";
      rev = "03f63972b7238a179123f4cb3fa2c2539d5a6dea";
      hash = "sha256-UvG1teqFaOsh0osFhGVAGAU0vgTMnz2wt3GZK+9IuRY=";
    };

    patches = (prevAttrs.patches or [ ]) ++ [
      # suppresses ctrl/alt text input on wayland
      ./0001-Key-Modifiers-Fix.patch
      # reports window size after leaving fullscreen
      ./0002-Fix-Window-size-on-unset-fullscreen.patch
      # downgrades wayland icon unsupported error to warning
      ./0003-Avoid-error-on-startup.patch

      # downgrades wayland window position unsupported errors to warnings
      ./0004-Dismiss-warnings-about-window-position-being-unavail.patch
      # keeps native test target windows-only
      ./0005-Fix-test-native-target.patch

      # pointer warp support is poor across compositors; use pointer constraints instead
      # https://wayland.app/protocols/pointer-warp-v1#compositor-support
      ./0006-Implement-glfwSetCursorPosWayland-via-pointer-constr.patch
    ];
  }
)
