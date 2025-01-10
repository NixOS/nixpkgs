{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "microfetch";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    tag = "v${version}";
    hash = "sha256-SY7Eln0Hwj0VWqzzYfqsVpAMES+SCiZkLgNZR3a8d7A=";
  };

  cargoHash = "sha256-a9iPTMPviHqXanqB7k2ecdkSJ2RwSErj8BWeqNUPiAo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Microscopic fetch script in Rust, for NixOS systems";
    homepage = "https://github.com/NotAShelf/microfetch";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nydragon
      NotAShelf
    ];
    mainProgram = "microfetch";
    platforms = lib.platforms.linux;
  };
}
