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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cook-cli";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-d2sO25QtElhAATgUeyDQaYMN2ZC7r6Nj8IH9xe+pabs=";
  };

  cargoHash = "sha256-i8vE4iMe8JfghR2k9pNP3CkZlXP+87eF3MZfCBLxhiM=";

  # Build without the self-updating feature
  buildNoDefaultFeatures = true;

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
