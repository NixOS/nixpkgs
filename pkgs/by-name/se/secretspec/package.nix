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
  version = "0.5.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-hrjR+4XrvmgnO1EsHNFq9FoBkK2rgJLpAbz4rOnRLHw=";
  };

  cargoHash = "sha256-fbxMKz2fIFnqJ0BM5pyYoVrC06ymmBrvTatItfM82po=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    mainProgram = "secretspec";
  };
})
