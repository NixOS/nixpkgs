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
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Create, update, and query Radicle Job Collaborative Objects";
    homepage = finalAttrs.src.homeUrl;
    changelog = "${finalAttrs.src.homeUrl}/tree/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "rad-job";
  };
})
