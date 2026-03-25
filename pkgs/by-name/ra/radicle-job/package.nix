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
  version = "0.5.2";

  src = fetchFromRadicle {
    seed = "seed.radicle.xyz";
    repo = "z2UcCU1LgMshWvXj6hXSDDrwB8q8M";
    tag = "releases/v${finalAttrs.version}";
    hash = "sha256-kFlSig0eiUdw6GHwacNHtuGkuW14CkHkc3okN2ZeTns=";
  };

  cargoHash = "sha256-kZg2X9GXyqr1kj82Pxq6+tjhIXAhOk0vMeU0owSi7gU=";

  nativeCheckInputs = [
    radicle-node
    gitMinimal
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Create, update, and query Radicle Job Collaborative Objects";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z2UcCU1LgMshWvXj6hXSDDrwB8q8M";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z2UcCU1LgMshWvXj6hXSDDrwB8q8M/tree/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "rad-job";
  };
})
