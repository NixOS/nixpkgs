{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
  version = "0.3.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-g1mpdA024fy56aFk35iLnKdk75e+uFkXP1or9P5agbY=";
  };

  cargoHash = "sha256-uqolUCR2cBR3YFbOQzuSbi88a9ioKmFLsGwBhtBpHDI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ domenkozar ];
    mainProgram = "secretspec";
  };
})
