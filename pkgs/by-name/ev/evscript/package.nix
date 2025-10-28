{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "evscript";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "valpackett";
    repo = "evscript";
    rev = version;
    hash = "sha256-lCXDDLovUb5aSOPTyVJL25v1JT1BGrrUlUR0Mu0XX4Q=";
  };

  cargoHash = "sha256-L0qwHWxMf/Nd0B2FWLIpKLgrs2LRyTOwuG/7keMI2zE=";

  meta = with lib; {
    homepage = "https://codeberg.org/valpackett/evscript";
    description = "Tiny sandboxed Dyon scripting environment for evdev input devices";
    mainProgram = "evscript";
    license = licenses.unlicense;
    maintainers = with maintainers; [ milesbreslin ];
    platforms = platforms.linux;
  };
}
