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
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${version}";
    hash = "sha256-alrmQOt9PY155fIWXmp1m2dfhhkMOd4PkfkBWS2XXRg=";
  };

  cargoHash = "sha256-tYD49UrLzPPS8G2zy2GKFBK4SGYXQ7UEjFWKcHvUTSY=";

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
