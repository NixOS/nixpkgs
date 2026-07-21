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
  version = "0.16.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-YiKud3dfw6QmZbKVCY9FD5vrxJs9bE6++BvEeaDUiEs=";
  };

  cargoHash = "sha256-tXZ1KUjZWgddh8wD3oyeZWDe5XqdknyEQ0eu4LXPrf0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    mainProgram = "secretspec";
  };
})
