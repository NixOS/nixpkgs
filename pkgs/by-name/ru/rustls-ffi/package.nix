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
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "rustls-ffi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ayD9A9ZiQX3pkRJ4T+EyDsNroGuTdR2xEXcfz6D3MY8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-5FJb6cuQMT2NWQvbxip+medxcEUtSnZaKu8QR2YFKzc=";
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
