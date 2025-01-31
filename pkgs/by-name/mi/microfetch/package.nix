{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "microfetch";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    tag = "v${version}";
    hash = "sha256-qpwzuzEqXsGO4y3ClaY25Q4rFm2RyPl/X3yNcQz3R4E=";
  };

  cargoHash = "sha256-NUEonhVIjDn1IblVnSQPe2gkKRW/icoq/I3EZTYMHZo=";

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
