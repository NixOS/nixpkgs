{
  lib,
  rustPlatform,
  fetchFromRadicle,
  radicle-node,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-job";
  version = "0.6.0";

  src = fetchFromRadicle {
    seed = "seed.radicle.dev";
    repo = "z2UcCU1LgMshWvXj6hXSDDrwB8q8M";
    tag = "releases/v${finalAttrs.version}";
    hash = "sha256-RZDItJq42yewct1kYnDLpr6Oun0AmHK9jMoQDORHkWc=";
  };

  cargoHash = "sha256-kXgJEEvEAJTV9lok3f26WkEPHFHFopdqxSii49xwK+A=";

  nativeCheckInputs = [
    radicle-node
    gitMinimal
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Create, update, and query Radicle Job Collaborative Objects";
    homepage = "https://radicle.network/nodes/seed.radicle.dev/rad:z2UcCU1LgMshWvXj6hXSDDrwB8q8M";
    changelog = "https://radicle.network/nodes/seed.radicle.dev/rad:z2UcCU1LgMshWvXj6hXSDDrwB8q8M/tree/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    teams = [ lib.teams.radicle ];
    mainProgram = "rad-job";
  };
})
