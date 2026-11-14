{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  cargo-c,
  stdenv,
  testers,
  validatePkgConfig,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "resvg";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "linebender";
    repo = "resvg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3u+NvpiBV1Q56pE5sLpoeqGoKjxLcr3PfXKZNtYKBR8=";
  };

  cargoHash = "sha256-CVnU64Yi//vZz6rza05teA8bFlhbgdeky0Bd7RvIX7M=";

  cargoBuildFlags = [
    "--package=resvg"
    "--package=resvg-capi"
    "--package=usvg"
  ];

  nativeBuildInputs = [
    cargo-c
    validatePkgConfig
  ];

  postBuild = ''
    ${buildPackages.rust.envVars.setEnv} cargo cbuild -p resvg-capi \
      -j $NIX_BUILD_CORES \
      --frozen \
      --release \
      --prefix=$out \
      --target=${stdenv.hostPlatform.rust.rustcTarget}
  '';

  postInstall = ''
    ${buildPackages.rust.envVars.setEnv} cargo cinstall -p resvg-capi \
      -j $NIX_BUILD_CORES \
      --frozen \
      --release \
      --prefix=$out \
      --target=${stdenv.hostPlatform.rust.rustcTarget}

    install -Dm644 -t $out/include crates/c-api/*.h
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "SVG rendering library";
    homepage = "https://github.com/linebender/resvg";
    changelog = "https://github.com/linebender/resvg/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = [ lib.maintainers.jopejoe1 ];
    mainProgram = "resvg";
    pkgConfigModules = [ "resvg" ];
  };
})
