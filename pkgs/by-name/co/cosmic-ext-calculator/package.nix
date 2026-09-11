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
  libqalculate,
  just,
  nix-update-script,
  fetchpatch,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-ext-calculator";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "calculator";
    tag = finalAttrs.version;
    hash = "sha256-t8xuM0B2eh2AbAhDgSOGapTwmmm9eC+wHsqwq4Jn5yU=";
  };

  cargoHash = "sha256-a4WckNyKXS71dT0uYbO7tUUmD0Dw8vSzrPp29O4aiAk=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-calculator"
  ];

  preFixup = ''
    libcosmicAppWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ libqalculate ]}
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/cosmic-utils/calculator/releases/tag/${finalAttrs.version}";
    description = "Calculator for the COSMIC Desktop Environment";
    homepage = "https://github.com/cosmic-utils/calculator";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-calculator";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
