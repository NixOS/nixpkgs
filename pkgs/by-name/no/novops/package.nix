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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "PierreBeucher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9uX+YwCCIrf0BDioDL+G2z2ZNwYRFyPZa/mzTYXv51Y=";
  };

  cargoHash = "sha256-ib1iifqQezWqXxQKppm0ghz0qi5z0siZUMVPHufiC0k=";

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
