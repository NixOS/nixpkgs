{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  rustPlatform,
  pkg-config,
  openssl,
  nodejs,
  nix-update-script,
  withSync ? true,
  withServer ? true,
  withImport ? true,
  withLSP ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cook-cli";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wJUfbxFkrVg9bo+lsiwrF/mkskrAAGL78143Why+uoU=";
  };

  cargoHash = "sha256-rSKEqy0BUT5wyH7tyFEtxWOvKCzcqtXBgOdZPR178wg=";

  # Build without the self-updating feature
  buildNoDefaultFeatures = true;
  buildFeatures =
    lib.optional withSync "sync"
    ++ lib.optional withServer "server"
    ++ lib.optional withImport "import"
    ++ lib.optional withLSP "lsp";

  checkFlags = [
    # set to false because it fails a test
    # see this issue https://github.com/cooklang/cookcli/issues/440
    "--skip=test_help_output"
  ];

  nativeBuildInputs = [
    pkg-config
    openssl
    nodejs
    npmHooks.npmConfigHook
  ];

  buildInputs = [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = 1;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-ZSRd4tcAsR1tKZ8ZBcb95C1FWEaijsA0WQ5EME0cOfo=";
  };

  preBuild = ''
    npm run build-css
    npm run build-js
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/cooklang/cookcli/releases/tag/v${finalAttrs.version}";
    description = "Suite of tools to create shopping lists and maintain recipes";
    homepage = "https://cooklang.org/";
    license = lib.licenses.mit;
    mainProgram = "cook";
    maintainers = [
      lib.maintainers.emilioziniades
      lib.maintainers.ginkogruen
      lib.maintainers.pinage404
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
