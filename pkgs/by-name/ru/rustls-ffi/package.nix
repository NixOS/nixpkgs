{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  cargo-c,
  validatePkgConfig,
  buildPackages,
  libiconv,
  curl,
  apacheHttpd,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rustls-ffi";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "rustls-ffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m92kWH+J8wuGmI0msrp2aginY1K51iqgi3+u4ncmfts=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gqc6en59QQpD14hOgRuGEPWLvrkyGn9tPR9vQmRAxIg=";
  };

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    cargo-c
    validatePkgConfig
  ];

  buildPhase = ''
    runHook preBuild
    ${buildPackages.rust.envVars.setEnv} cargo cbuild -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${buildPackages.rust.envVars.setEnv} cargo cinstall -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${buildPackages.rust.envVars.setEnv} cargo ctest -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postCheck
  '';

  passthru.tests = {
    curl = curl.override {
      opensslSupport = false;
      rustlsSupport = true;
      rustls-ffi = finalAttrs.finalPackage;
    };
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "C-to-rustls bindings";
    homepage = "https://github.com/rustls/rustls-ffi/";
    pkgConfigModules = [ "rustls" ];
    license = with lib.licenses; [
      mit
      asl20
      isc
    ];
    maintainers = [ maintainers.lesuisse ];
  };
})
