{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  nix-update-script,
}:

let
  version = "0.5.4";
in
rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-lP65PrMFhbNoWyObFsJK06Hgv9w83hyI/YiKcL5rXhY=";
  };

  cargoHash = "sha256-sWYKJz/wfx0XG150cTOguvhdN3UEn8QE0P0+2lSeVkc=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Systemd unit switcher for Home Manager";
    mainProgram = "sd-switch";
    homepage = "https://git.sr.ht/~rycee/sd-switch";
    changelog = "https://git.sr.ht/~rycee/sd-switch/refs/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rycee ];
    platforms = lib.platforms.linux;
  };
}
