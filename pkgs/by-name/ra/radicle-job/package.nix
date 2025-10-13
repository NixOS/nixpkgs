{
  lib,
  rustPlatform,
  fetchFromRadicle,
  fetchRadiclePatch,
  radicle-node,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-job";
  version = "0.3.0";

  src = fetchFromRadicle {
    seed = "iris.radicle.xyz";
    repo = "z2UcCU1LgMshWvXj6hXSDDrwB8q8M";
    tag = "releases/v${finalAttrs.version}";
    hash = "sha256-6UrkKyIdSM5lSYNF/A3xIf3FGiM2pB/5s7F49jtn0KE=";
  };

  patches = [
    # https://app.radicle.xyz/nodes/rosa.radicle.xyz/rad:z2UcCU1LgMshWvXj6hXSDDrwB8q8M/patches/dac4fef89d07fe609dd5d3d75ea57f76f1cca3dc
    (fetchRadiclePatch {
      inherit (finalAttrs.src) seed repo;
      revision = "dac4fef89d07fe609dd5d3d75ea57f76f1cca3dc";
      hash = "sha256-oFUkiBIqAa/DWqlTZw0LzHbgK/uhWik8qbRcGcGpkDY=";
    })
  ];

  cargoHash = "sha256-5GjLqs4ol7lUE96KwtE7W3lxL9H/A/0yDpiMDiLQDeY=";

  nativeCheckInputs = [
    radicle-node
    gitMinimal
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/rad-job";
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
