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
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8gJlXxdZJpXe/50wzN8fT/M5JscC/mIdE3a74e+S2as=";
  };

  cargoHash = "sha256-fWD7rYPMdSJwsQ24o0cuZCqIggN+iXHAfRjx65YbXq8=";

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
    hash = "sha256-HbuCSCgEz9FZsb5DJ37twFdxsuin0k4osqb8BP6XEI0=";
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
