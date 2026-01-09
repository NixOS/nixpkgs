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
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${version}";
    hash = "sha256-qfsyEHQnOfJYqgZi5QxiGJX1pbXx7oR7qzBEwTYH7oY=";
  };

  cargoHash = "sha256-xQTMxas5gO17DvNXvxdJ03Rhd4kaJPBf+GikbCE1fWI=";

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
