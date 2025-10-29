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
  version = "0.4.0";

  src = fetchFromRadicle {
    seed = "iris.radicle.xyz";
    repo = "z2UcCU1LgMshWvXj6hXSDDrwB8q8M";
    tag = "releases/v${finalAttrs.version}";
    hash = "sha256-EGNs0IOJSp5SMJ3tdGCxIAN6hvVFwWWUmXoB914jw3k=";
  };

  cargoHash = "sha256-+DD2cGfxN0rmFhCazEuRiv3JfLXIC4FjaYHmugCmk+g=";

  nativeCheckInputs = [
    radicle-node
    gitMinimal
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Create, update, and query Radicle Job Collaborative Objects";
    homepage = "https://app.radicle.xyz/nodes/iris.radicle.xyz/rad:z2UcCU1LgMshWvXj6hXSDDrwB8q8M";
    changelog = "https://app.radicle.xyz/nodes/iris.radicle.xyz/rad:z2UcCU1LgMshWvXj6hXSDDrwB8q8M/tree/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "rad-job";
  };
})
