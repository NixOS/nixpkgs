# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: Lily Foster <lily@lily.flowers>
# Portions of this code are adapted from nixos-cosmic
# https://github.com/lilyinstarlight/nixos-cosmic
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-reader";
  version = "0-unstable-2025-01-14";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-reader";
    rev = "9ea7c8513a06a7f5968db7eaa6273dd3dc411072";
    hash = "sha256-NmpgC0e4igDNV7RtqabR9EE3QNsMksU+Q7m9R0zD1Ic=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zzOHisojObvprCFV2uhnei2cmtfogZSbii2ceuiRhv8=";

  nativeBuildInputs = [ libcosmicAppHook ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    description = "PDF reader for the COSMIC Desktop Environment";
    homepage = "https://github.com/pop-os/cosmic-reader";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-reader";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cosmic ];
  };
}
