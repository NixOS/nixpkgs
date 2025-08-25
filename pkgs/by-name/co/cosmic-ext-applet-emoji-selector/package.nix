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
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "leb-kuchen";
    repo = "cosmic-ext-applet-emoji-selector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tUfrurThxN++cZiCyVHr65qRne9ZXzWtMuPb0lqOijE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vI8pIOo8A9Ebyati4c0CyGxuf4YQKEaSdG28CQ1/w3w=";

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

  passthru.updateScript = nix-update-script { };

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
