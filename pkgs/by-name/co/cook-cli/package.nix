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
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${version}";
    hash = "sha256-lNR+MqNRRy/r50wNTmoy0HZ2BxYmH8LbEdyDOWJH6rA=";
  };

  cargoHash = "sha256-16oIOaam9pVVVjJs88+s/Nlrw78KTi1+QzS5eqJkvXE=";

  cargoPatches = [
    # This patch fixes duplicate dependencies in `Cargo.lock` which caused `cargo vendor` to fail.
    # For this the dependency on the `cooklang 0.17.0` crate was replaced
    # with the more specialized `cooklang 0.17.0` git dependency.
    ./remove-duplicate-cargo-dependency.patch
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

  OPENSSL_NO_VENDOR = 1;

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-HxC9Tf+PZvvETuNqm1W3jaZx7SpYXlxZlI8FwGouK+s=";
  };

  preBuild = ''
    npm run build-css
  '';

  # Build without the self-updating feature
  buildNoDefaultFeatures = true;

  checkFlags = [
    # Disabled `test_help_output` as the testing suite doesn't account for building without default features.
    # The test would fail with the 'update' subcommand rightfully missing from the output of `cook --help`.
    "--skip=test_help_output"
  ];

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
