{
  glfw3,
  fetchFromGitHub,
}:
glfw3.overrideAttrs (
  finalAttrs: prevAttrs: {
    pname = "glfw-minecraft";
    version = "3.5-unstable-2026-04-02";

    src = fetchFromGitHub {
      owner = "LWJGL-CI";
      repo = "GLFW";
      rev = "0e6ee09b1c777968eb5a1da924794c6f4602fdc8";
      hash = "sha256-/H0Rscp4zTXn5k3A+134fzVzBdtfZ6q/3DJytuRshLc=";
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
