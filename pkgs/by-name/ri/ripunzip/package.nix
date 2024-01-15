{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, darwin
, pkg-config
, testers
, fetchzip
, ripunzip
}:

rustPlatform.buildRustPackage rec {
  pname = "ripunzip";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "ripunzip";
    rev = "v${version}";
    hash = "sha256-GyP4OPnPKhu9nXYXIfWCVLF/thwWiP0OqAQY/1D05LE=";
  };

  cargoHash = "sha256-Jv9bCHT5xl/2CPnSuWd9HZuaGOttBC5iAbbpr3jaIhM=";

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security SystemConfiguration ]);
  nativeBuildInputs = [ pkg-config ];

  setupHook = ./setup-hook.sh;

  passthru.tests = {
    fetchzipWithRipunzip = testers.invalidateFetcherByDrvHash (fetchzip.override { unzip = ripunzip; }) {
      url = "https://github.com/google/ripunzip/archive/cb9caa3ba4b0e27a85e165be64c40f1f6dfcc085.zip";
      hash = "sha256-BoErC5VL3Vpvkx6xJq6J+eUJrBnjVEdTuSo7zh98Jy4=";
    };
    version = testers.testVersion {
      package = ripunzip;
    };
  };

  meta = with lib; {
    description = "A tool to unzip files in parallel";
    homepage = "https://github.com/google/ripunzip";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = [ maintainers.lesuisse ];
  };
}
