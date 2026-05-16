{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  nix-update-script,
}:

let
  version = "0.6.3";
in
rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-0cK5Gt/+M7IfPPthmx6Z11FymnsXagyT/PZtboQY72k=";
  };

  cargoHash = "sha256-ZIvq+SnnuXr8j6ae5WEf9aZZm20wB4HWQOmOrn08KIc=";

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
