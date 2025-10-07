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
  bash,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-idle";
  version = "1.0.0-beta.1.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-idle";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-dRvcow+rZ4sJV6pBxRIw6SCmU3aXP9uVKtFEJ9vozzI=";
  };

  cargoHash = "sha256-iFR0kFyzawlXrWItzFQbG/tKGd3Snwk/0LYkPzCkJUQ=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
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

  postPatch = ''
    substituteInPlace src/main.rs --replace-fail '"/bin/sh"' '"${lib.getExe' bash "sh"}"'
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
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    description = "Idle daemon for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-idle";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-idle";
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
