{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "microfetch";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    rev = "refs/tags/v${version}";
    hash = "sha256-mK1sBcTieMjYneMhkuxoOt5+fELcyjH9+SQpzs7542Y=";
  };

  cargoHash = "sha256-LEw7z73Jm7/mJomN6yy87iCFauXifA+vffn/drXwqpY=";

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
