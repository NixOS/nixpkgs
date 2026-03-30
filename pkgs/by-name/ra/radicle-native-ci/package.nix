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
  version = "0.14.0";

  src = fetchFromRadicle {
    seed = "seed.radicle.xyz";
    repo = "z3qg5TKmN83afz2fj9z3fQjU8vaYE";
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u0KuQ+ii1lRl2f0SduZZtapuDHeSvl9T00esHeCuIq4=";
  };

  cargoHash = "sha256-6Hkyf9siagH/GPVxOePpkV2BMloXEamrJSJCnEfIeSo=";

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
    teams = [ lib.teams.radicle ];
    mainProgram = "radicle-native-ci";
  };
})
