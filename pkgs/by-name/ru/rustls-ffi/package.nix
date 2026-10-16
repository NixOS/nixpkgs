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
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "rustls-ffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SJhm/krDU7dMH99ULJ0EOMCxP69/ueQKCWrt00G3m8g=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-hiBMosPc77z0Z6xeP9wnh0B9mFDTXQ7nZ3OExO4leTs=";
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
      http3Support = false; # rustls-ffi doesn't yet support QUIC
      rustls-ffi = finalAttrs.finalPackage;
    };
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "C-to-rustls bindings";
    homepage = "https://github.com/rustls/rustls-ffi/";
    pkgConfigModules = [ "rustls" ];
    license = with lib.licenses; [
      mit
      asl20
      isc
    ];
    maintainers = [
      lib.maintainers.lesuisse
      lib.maintainers.cpu
    ];
  };
})
