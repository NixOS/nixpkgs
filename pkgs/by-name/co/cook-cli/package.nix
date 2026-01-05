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
rustPlatform.buildRustPackage rec {
  pname = "cook-cli";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${version}";
    hash = "sha256-yNUiwMzCAj5aXuQIzfzpy2GylhB37CuSmyHsyxcmKXM=";
  };

  cargoHash = "sha256-Kq70YgTis5e8PcIAOgAqk/fi3HmE+lbpYjaV47axGX4=";

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

  OPENSSL_NO_VENDOR = 1;

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-HxC9Tf+PZvvETuNqm1W3jaZx7SpYXlxZlI8FwGouK+s=";
  };

  preBuild = ''
    npm run build-css
  '';

  meta = {
    changelog = "https://github.com/cooklang/cookcli/releases/tag/v${version}";
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
}
