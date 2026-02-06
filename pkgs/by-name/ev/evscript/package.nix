{
  lib,
  rustPlatform,
  fetchFromCodeberg,
}:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "0.1.0";

  src = fetchFromCodeberg {
    owner = "valpackett";
    repo = "evscript";
    rev = version;
    hash = "sha256-lCXDDLovUb5aSOPTyVJL25v1JT1BGrrUlUR0Mu0XX4Q=";
  };

  cargoHash = "sha256-L0qwHWxMf/Nd0B2FWLIpKLgrs2LRyTOwuG/7keMI2zE=";

  meta = {
    homepage = "https://codeberg.org/valpackett/evscript";
    description = "Tiny sandboxed Dyon scripting environment for evdev input devices";
    mainProgram = "evscript";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ milesbreslin ];
    platforms = lib.platforms.linux;
  };
}
