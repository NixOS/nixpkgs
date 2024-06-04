{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.9";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cN5GtU3bmsdJvfjVdWvWAshiU3Ged7L9pc8wid8GQwA=";
  };

  cargoHash = "sha256-ngDA085V3+2oBH13Fs+pJez2W2/i1pEKoWdqJ4/3Q0I=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    changelog = "https://github.com/tarkah/tickrs/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
    mainProgram = "tickrs";
  };
}
