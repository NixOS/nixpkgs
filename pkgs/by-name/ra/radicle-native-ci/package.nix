{
  lib,
  rustPlatform,
  fetchFromRadicle,
  radicle-node,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-native-ci";
  version = "0.11.1";

  src = fetchFromRadicle {
    seed = "seed.radicle.xyz";
    repo = "z3qg5TKmN83afz2fj9z3fQjU8vaYE";
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OjQBq4QopT4dr1/z73fqlGLjQIjUY51/II9m2qQMW1w=";
  };

  cargoHash = "sha256-zyEdlAXaooEkxD4aZ1poIUX3OwXtP4nFAyOWJDdw1p8=";

  preCheck = ''
    git config --global user.name nixbld
    git config --global user.email nixbld@example.com
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    radicle-node
    gitMinimal
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Radicle CI adapter for native CI";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z3qg5TKmN83afz2fj9z3fQjU8vaYE";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z3qg5TKmN83afz2fj9z3fQjU8vaYE/tree/NEWS.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "radicle-native-ci";
  };
})
