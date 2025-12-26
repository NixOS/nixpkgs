{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "microfetch";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    tag = "v${version}";
    hash = "sha256-F3yRJrOzBzSDLadVTZqOPMaqF+3NSzedi222EawqVWQ=";
  };

  cargoHash = "sha256-Ewtge3yaegzZM4DgUXSquyJM7xcpmSp6lLmMrfrgy4Y=";

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
