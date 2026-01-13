{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitHub,
  rustPlatform,
  ...
}:

let
  rustOverlaySrc = fetchFromGitHub {
    owner = "oxalica";
    repo = "rust-overlay";
    rev = "master";
    hash = lib.fakeHash;
  };

  rustOverlay = import rustOverlaySrc;

  pkgsWithRust = import <nixpkgs> {
    system = stdenv.hostPlatform.system;
    overlays = [ rustOverlay ];
  };

  toolchain = pkgsWithRust.rust-bin.stable."1.92.0".default;

  rustPlatformPinned = pkgsWithRust.makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
rustPlatformPinned.buildRustPackage rec {
  pname = "hyprlog";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gusjengis";
    repo = "hyprlog";
    rev = "v${version}";
    hash = "sha256-GQ/vF5Ebp3l2C6GgCqSFMK25xHTgJINByqV8ksm/Vl0=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  meta = with lib; {
    description = "Hyprland focus/activity logger";
    homepage = "https://github.com/gusjengis/hyprlog";
    license = licenses.mit;
    mainProgram = "hyprlog";
    platforms = platforms.linux;
  };
}
