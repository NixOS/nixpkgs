{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "microfetch";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "microfetch";
    rev = "refs/tags/v${version}";
    hash = "sha256-EfQs9CdbWhf/elujUO/N3TU5TiQJalYMqRGbPIGiMwg=";
  };

  cargoHash = "sha256-/pRkF8xp0bOsliJPlQNQBkkeSf1cFe+yBo4CzMbcnKM=";

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
