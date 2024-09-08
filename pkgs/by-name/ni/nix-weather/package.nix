{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-weather";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "cafkafk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4zcdQ28MejGgdyZgqQD2XHWj/PBDq4aW78jyeBDv2h8=";
  };

  cargoHash = "sha256-Hj9cB1CY6SEwwin85QnDy9+0dMhlKdnp2IE2yM5a9C8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Check Cache Availablility of NixOS Configurations";
    longDescription = ''
      fast rust tool to check availability of your entire system in caches. It so to speak "checks the weather" before going to update.

      Heavily inspired by guix weather.
    '';
    homepage = "https://git.fem.gg/cafkafk/nix-weather";
    changelog = "https://git.fem.gg/cafkafk/nix-weather/releases/tag/v${version}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      freyacodes
      cafkafk
    ];
    mainProgram = "nix-weather";
    platforms = lib.platforms.all;
  };
}
