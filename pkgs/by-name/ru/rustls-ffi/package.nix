{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  cargo-c,
  validatePkgConfig,
  libiconv,
  curl,
  testers,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustls-ffi";
  version = "0.15.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-Ob5e3qEQIUjeiA9w4DGPKkw8C3l7Vrq2Y33uK1dua2Y=";
  };

  cargoHash = "sha256-pvQyoInSupI7cazaLaKiZILVzLYtJW++B1WD0dgBahE=";

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # TODO: Replacing stdenv.mkDerivation with rustPlatform.buildRustPackage
  #   causes test test_acceptor_success to fail
  doCheck = false;

  dontCargoBuild = true;
  dontCargoInstall = true;
  dontCargoCheck = true;

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    cargo-c
    validatePkgConfig
  ];

  passthru.tests = {
    curl = curl.override {
      opensslSupport = false;
      rustlsSupport = true;
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
    maintainers = [ lib.maintainers.lesuisse ];
  };
})
