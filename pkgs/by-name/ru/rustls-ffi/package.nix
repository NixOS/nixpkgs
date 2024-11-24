{ lib
, stdenv
, fetchFromGitHub
, cargo
, rustPlatform
, cargo-c
, validatePkgConfig
, rust
, libiconv
, darwin
, curl
, apacheHttpd
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rustls-ffi";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "rustls-ffi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Bc9bVZ2pDsG118l/SlElZpgh9F1JEgPF8LzBX7d4mhE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-gDQ9AFrJuV7SrzKCAHQBkKj6clXuPLO0DHhnvcBqRLs=";
  };

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  nativeBuildInputs = [ cargo rustPlatform.cargoSetupHook cargo-c validatePkgConfig ];

  buildPhase = ''
    runHook preBuild
    ${rust.envVars.setEnv} cargo cbuild -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${rust.envVars.setEnv} cargo cinstall -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${rust.envVars.setEnv} cargo ctest -j $NIX_BUILD_CORES --release --frozen --prefix=${placeholder "out"} --target ${stdenv.hostPlatform.rust.rustcTarget}
    runHook postCheck
  '';

  passthru.tests = {
    curl = curl.override { opensslSupport = false; rustlsSupport = true; rustls-ffi = finalAttrs.finalPackage; };
    apacheHttpd = apacheHttpd.override { modTlsSupport = true; rustls-ffi = finalAttrs.finalPackage; };
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "C-to-rustls bindings";
    homepage = "https://github.com/rustls/rustls-ffi/";
    pkgConfigModules = [ "rustls" ];
    license = with lib.licenses; [ mit asl20 isc ];
    maintainers = [ maintainers.lesuisse ];
  };
})
