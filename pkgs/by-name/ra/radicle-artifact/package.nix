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
  version = "0.19.0";

  __structuredAttrs = true;

  src = fetchFromRadicle {
    seed = "radicle.norman.life";
    repo = "z4VYyJ9KuwMNkXGQnmKuGPGKw3inv";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-b+yi/Kqmtn1Lpnc7Vt1Od0DAx6cOahrru0+Lb6hbM10=";
  };

  cargoHash = "sha256-EPDkr9qT5X8n3FO3v8RSpTl1Alz1zndu5RExN7gPXxk=";

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
