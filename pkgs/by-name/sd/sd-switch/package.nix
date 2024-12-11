{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  nix-update-script,
}:

let
  version = "0.5.2";
in
rustPlatform.buildRustPackage {
  pname = "sd-switch";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~rycee";
    repo = "sd-switch";
    rev = version;
    hash = "sha256-vxDb5NkzmcWL6ECueultg6NoYMObW/54UuMLJe+AjVs=";
  };

  cargoHash = "sha256-Oh4thw4NOjYjdLJWHG4wH7VDYjD89apl4S2JFM14WWw=";

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
