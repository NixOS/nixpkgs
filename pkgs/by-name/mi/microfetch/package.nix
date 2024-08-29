{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "microfetch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    rev = "refs/tags/v${version}";
    hash = "sha256-bRN16Iq9m6HaeT+KWCpeukTu1tnMOvtM6lDHO5OiIS4=";
  };

  cargoHash = "sha256-dGlAiPrOWFI8ogo/1S2ZK/ZPBtKGCyA72B+6B4bp5Mg=";

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
