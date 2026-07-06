{
  lib,
  fetchFromCodeberg,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "re-appintentsmetadataprocessor";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "viraptor";
    repo = "re-appintentsmetadataprocessor";
    tag = finalAttrs.version;
    hash = "sha256-yZZd1j1V9hNFg1zZmXoNwDi9aueoEIqnptS+NityGlg=";
  };

  cargoHash = "sha256-mkev7O6eO2ddFoP3Gm6r+2kllnz2c9HiYADjFZXQIHo=";

  meta = {
    mainProgram = "appintentsmetadataprocessor";
    description = "Open reimplementation of Apple's appintentsmetadataprocessor";
    homepage = "https://codeberg.org/viraptor/re-appintentsmetadataprocessor";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ viraptor ];
    platforms = lib.platforms.unix;
  };
})
