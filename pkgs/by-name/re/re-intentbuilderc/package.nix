{
  lib,
  fetchFromCodeberg,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "re-intentbuilderc";
  version = "1.0.2";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "viraptor";
    repo = "re-intentbuilderc";
    tag = finalAttrs.version;
    hash = "sha256-MucaZ+5MfwMj2nxMcKONxlVXaeHJnN1KVvP2961dQIY=";
  };

  cargoHash = "sha256-9PmIoXngNuWUXYa1f4CS5JS1yh+/9E8GBfjndIFEqTk=";

  meta = {
    mainProgram = "intentbuilderc";
    description = "Open reimplementation of Apple's intentbuilderc";
    homepage = "https://codeberg.com/viraptor/re-intentbuilderc";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ viraptor ];
    platforms = lib.platforms.unix;
  };
})
