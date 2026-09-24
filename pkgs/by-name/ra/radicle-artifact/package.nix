{
  lib,
  rustPlatform,
  fetchFromRadicle,
  stdenv,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-artifact";
  version = "0.20.0";

  __structuredAttrs = true;

  src = fetchFromRadicle {
    seed = "radicle.norman.life";
    repo = "z4VYyJ9KuwMNkXGQnmKuGPGKw3inv";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-tFsoWTgvGGooug6c0WsPJaSn+1HlaK0A2rH+NK+IwOM=";
  };

  cargoHash = "sha256-65oX65F0rDeYICL4XUUjS2mMaraBVX3MytBj25MKQv0=";

  nativeCheckInputs = [ gitMinimal ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # tests segfault on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Secure artifact distribution for Radicle";
    homepage = "https://radicle.network/nodes/radicle.norman.life/rad:z4VYyJ9KuwMNkXGQnmKuGPGKw3inv";
    changelog = "https://radicle.network/nodes/radicle.norman.life/rad:z4VYyJ9KuwMNkXGQnmKuGPGKw3inv/tree/CHANGELOG.md";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    teams = [ lib.teams.radicle ];
    mainProgram = "rad-artifact";
  };
})
