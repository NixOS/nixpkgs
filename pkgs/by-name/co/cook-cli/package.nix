{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  rustPlatform,
  pkg-config,
  openssl,
  sqlite,
  nodejs,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cook-cli";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q3dQSnRJaecYkDWTwh/k3PROOSp+1uvQP9yNcCsnnc4=";
  };

  cargoHash = "sha256-YSpZDF/YkZ+UsEHK2pJkZSWUc/B2aPeMs6xoyGy69fs=";

  # Build without the self-updating feature
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "sync"
    "server"
    "import"
    "lsp"
  ];

  nativeBuildInputs = [
    pkg-config
    openssl
    nodejs
    npmHooks.npmConfigHook
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  env.OPENSSL_NO_VENDOR = 1;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-rQDKNk7PQdYBvtah8oziVWWaKT55zd6vu/KghMceGek=";
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
