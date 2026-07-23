{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  rustPlatform,
  pkg-config,
  openssl,
  nodejs,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cook-cli";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UwO/pdop4grOuVEq0pSt9DXEQLCXKFrm9HhfQISdBXg=";
  };

  cargoHash = "sha256-VobG+Ux56TNM3U2Y51/x59rpg27b2FZXTqpRcKttCEc=";

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
    hash = "sha256-tBOBa2plgJ0dG5eDD9Yc9YS+Dh6rhBdqU6JiZUjTUY4=";
  };

  preBuild = ''
    npm run build-css
  '';

  meta = {
    changelog = "https://github.com/cooklang/cookcli/releases/tag/v${finalAttrs.version}";
    description = "Suite of tools to create shopping lists and maintain recipes";
    homepage = "https://cooklang.org/";
    license = lib.licenses.mit;
    mainProgram = "cook";
    maintainers = [
      lib.maintainers.emilioziniades
      lib.maintainers.ginkogruen
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
