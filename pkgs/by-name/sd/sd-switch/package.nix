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

  useFetchCargoVendor = true;
  cargoHash = "sha256-sWYKJz/wfx0XG150cTOguvhdN3UEn8QE0P0+2lSeVkc=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Systemd unit switcher for Home Manager";
    mainProgram = "sd-switch";
    homepage = "https://git.sr.ht/~rycee/sd-switch";
    changelog = "https://git.sr.ht/~rycee/sd-switch/refs/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.linux;
  };
}
