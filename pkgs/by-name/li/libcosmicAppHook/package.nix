# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic

{
  lib,
  stdenv,
  makeSetupHook,
  runCommand,
  makeBinaryWrapper,
  pkg-config,
  targetPackages,
  cosmic-icons,
  cosmic-settings,
  libGL,
  libxkbcommon,
  libxi,
  libxcursor,
  libx11,
  libxcb,
  wayland,
  vulkan-loader,

  includeSettings ? true,
}:

makeSetupHook {
  name = "libcosmic-app-hook";

  propagatedBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  # ensure deps for linking below are available
  depsTargetTargetPropagated =
    assert (lib.assertMsg (!targetPackages ? raw) "libcosmicAppHook must be in nativeBuildInputs");
    [
      libGL
      libxkbcommon
      libx11
      libxcursor
      libxi
      libxcb
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      wayland
      vulkan-loader
    ];

  substitutions = {
    fallbackXdgDirs =
      let
        fallbackThemes = runCommand "cosmic-fallback-themes" { } ''
          mkdir -p $out/share
          ln -s ${targetPackages.cosmic-settings or cosmic-settings}/share/cosmic $out/share/cosmic
        '';
      in
      lib.makeSearchPath "share" (
        lib.optionals includeSettings [ fallbackThemes ] ++ [ targetPackages.cosmic-icons or cosmic-icons ]
      );
    cargoLinkerVar = stdenv.targetPlatform.rust.cargoEnvVarTarget;
    # force linking for all libraries that may be dlopen'd by libcosmic/iced apps
    cargoLinkLibs = lib.escapeShellArgs (
      [
        # for wgpu-hal
        "EGL"
        # for xkbcommon-dl
        "xkbcommon"
        # for x11-dl, tiny-xlib, wgpu-hal
        "X11"
        # for x11-dl, tiny-xlib
        "X11-xcb"
        # for x11-dl
        "Xcursor"
        "Xi"
        # for x11rb
        "xcb"
      ]
      ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
        # for wgpu-hal, wayland-sys
        "wayland-client"
        # for wgpu-hal
        "wayland-egl"
        "vulkan"
      ]
    );
  };

  meta = {
    description = "Setup hook for configuring and wrapping applications based on libcosmic";
    teams = [ lib.teams.cosmic ];
  };
} ./libcosmic-app-hook.sh
