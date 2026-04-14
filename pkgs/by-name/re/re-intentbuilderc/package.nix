{
  lib,
  fetchFromCodeberg,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "re-intentbuilderc";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "viraptor";
    repo = "re-intentbuilderc";
    tag = version;
    hash = "sha256-OO150Arb07dyMRDTYkFZ1xgx33eN/O4hXSU2L9KX/rw=";
  };

  cargoHash = "sha256-c2dQoLfaJul00vbj6cWj+sQi/GLZef8JkpZuPFlqKzI=";

  meta = {
    mainProgram = "intentbuilderc";
    description = "Open reimplementation of Apple's intentbuilderc";
    homepage = "https://codeberg.com/viraptor/re-intentbuilderc";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ viraptor ];
    platforms = lib.platforms.unix;
  };
}
