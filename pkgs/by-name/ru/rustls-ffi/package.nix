{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  darwin,
  curl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustls-ffi";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "rustls-ffi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZKAyKcKwhnPE6PrfBFjLJKkTlGbdLcmW1EP/xSv2cpM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cZ92wSKoygt9x6O/ginOEiCiarlR5qGVFOHrIFdWOWE=";

  buildCAPIOnly = true;
  doCheck = false;

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.Security
  ];

  passthru.tests = {
    curl = curl.override {
      opensslSupport = false;
      rustlsSupport = true;
      rustls-ffi = finalAttrs.finalPackage;
    };
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
