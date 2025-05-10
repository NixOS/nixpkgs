{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "microfetch";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    tag = "v${version}";
    hash = "sha256-iNx1/My72i+Ni/WVqF2HFgLjqH6W6WPupdOkH6UQH9E=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UguHTRHdcogxg/8DmRWSE7XwmaF36MTGHzF5CpMBc3Y=";

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
