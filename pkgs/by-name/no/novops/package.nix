{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, stdenv
, libiconv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "novops";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "PierreBeucher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LrEPdEVWgbZ6WyEqdfAhUjKXPuk8Xx7kmLA2ZsPFf1U=";
  };

  cargoHash = "sha256-kI836Z0fgpmPPoX0HtWkZG731xaVWgWkXF0eCaQfM28=";

  buildInputs = [
    openssl # required for openssl-sys
  ] ++ lib.optional stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeBuildInputs = [
    pkg-config # required for openssl-sys
  ];

  cargoTestFlags = [
      # Only run lib tests (unit tests)
      # All other tests are integration tests which should not be run with Nix build
      "--lib"
  ];

  meta = with lib; {
    description = "Cross-platform secret & config manager for development and CI environments";
    homepage = "https://github.com/PierreBeucher/novops";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ pbeucher ];
    mainProgram = "novops";
  };
}
