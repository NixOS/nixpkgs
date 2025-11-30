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
rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-calculator";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "calculator";
    tag = version;
    hash = "sha256-qPo+Qi6P0m3rNA6Qo6iNsgzGyirPqzXk4nj3OG6IuZ0=";
  };

  cargoHash = "sha256-Pq1E4O6lZMe+wKJgQKDBmgdsJJsJTyK0FDXU53n+Di4=";

  # TODO: Remove in the next release
  patches = [
    (fetchpatch {
      url = "https://github.com/cosmic-utils/calculator/commit/fc176a8d5d8af7fd808d450a78635432db6b64e6.patch";
      hash = "sha256-amSB+67rwCUqfqOTFGCkInvoZmA//wAR0viuvNdPkuc=";
    })
  ];

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
    changelog = "https://github.com/cosmic-utils/calculator/releases/tag/${version}";
    description = "Calculator for the COSMIC Desktop Environment";
    homepage = "https://github.com/cosmic-utils/calculator";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-calculator";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
