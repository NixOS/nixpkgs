# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic
{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  just,
  pkg-config,
  alsa-lib,
  ffmpeg,
  glib,
  gst_all_1,
  libglvnd,
  libgbm,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-player";
  version = "1.1.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-player";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-aHQbwpNr8tsfUR0Dm4WTzz6XNXjgdqZ9/2AQRPPbnog=";
  };

  cargoHash = "sha256-KVaKTMrWijResBqzH62j/YqBR4TQ77x2sK/kN40UWjw=";

  separateDebugInfo = true;
  __structuredAttrs = true;

  env.VERGEN_GIT_SHA = finalAttrs.src.tag;

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    libgbm
    libglvnd
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  preFixup = ''
    libcosmicAppWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-player";
    description = "Media player for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-player";
  };
})
