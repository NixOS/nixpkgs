{
  stdenv,
  lib,
  makeSetupHook,
  makeBinaryWrapper,
  pkg-config,
  libGL,
  libxkbcommon,
  xorg,
  wayland,
  vulkan-loader,
  targetPackages,
  includeSettings ? true,
}:

makeSetupHook {
  name = "libcosmic-app-hook";

  propagatedBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  # TODO: Xorg libs can be removed once tiny-xlib is bumped above 0.2.2 in libcosmic/iced
  depsTargetTargetPropagated =
    assert (lib.assertMsg (!targetPackages ? raw) "libcosmicAppHook must be in nativeBuildInputs");
    [
      libGL
      libxkbcommon
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      wayland
      vulkan-loader
    ];

  substitutions = {
    fallbackXdgDirs = "${lib.optionalString includeSettings "${targetPackages.cosmic-settings}/share:"}${targetPackages.cosmic-icons}/share";

    cargoLinkerVar = stdenv.hostPlatform.rust.cargoEnvVarTarget;
    cargoLinkLibs = lib.escapeShellArgs (
      [
        # propagated from libGL
        "EGL"
        # propagated from libxkbcommon
        "xkbcommon"
        # propagated from xorg.libX11
        "X11"
        # propagated from xorg.libXcursor
        "Xcursor"
        # propagated from xorg.libXi
        "Xi"
        # propagated from xorg.libXrandr
        "Xrandr"
      ]
      ++ lib.optionals (!stdenv.isDarwin) [
        # propagated from wayland
        "wayland-client"
        # propagated from vulkan-loader
        "vulkan"
      ]
    );
  };

  meta = {
    description = "Setup hook for configuring and wrapping applications based on libcosmic";
    maintainers = [
      lib.maintainers.nyanbinary
    ];
  };
} ./libcosmic-app-hook.sh
