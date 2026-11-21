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
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "linebender";
    repo = "resvg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lsJktYzwkWRzetU+rNLZrZSRT5jSNVPTtbwE3gnT5wk=";
  };

  cargoHash = "sha256-mvQNihyapelGFARE/EsTQV7sExz4ccMZYLIoIy7Yuak=";

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
