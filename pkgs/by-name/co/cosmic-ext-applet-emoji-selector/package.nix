# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic
{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  util-linux,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-applet-emoji-selector";
  version = "0.1.5-unstable-2025-06-12";

  src = fetchFromGitHub {
    owner = "bGVia3VjaGVu";
    repo = "cosmic-ext-applet-emoji-selector";
    rev = "f7333f23b235121b2c85787f82d94bf8804c6b50";
    hash = "sha256-BDI5tV6Gzbwtm6Vex46CYDpTqMupssOJUZU0YNGyIqM=";
  };

  cargoHash = "sha256-uEcxVaLCXVxSCkKPUgTom86ropE3iXiPyy6ITufWa5k=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    util-linux
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  installTargets = [
    "install"
    "install-schema"
  ];

  postPatch = ''
    substituteInPlace justfile \
      --replace-fail './target/release' './target/${stdenv.hostPlatform.rust.cargoShortTarget}/release' \
      --replace-fail '~/.config/cosmic' "$out/share/cosmic"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "Emoji selector applet for the COSMIC Desktop Environment";
    homepage = "https://github.com/leb-kuchen/cosmic-ext-applet-emoji-selector";
    license = with lib.licenses; [
      mit
      mpl20
    ];
    mainProgram = "cosmic-ext-applet-emoji-selector";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
  };
})
