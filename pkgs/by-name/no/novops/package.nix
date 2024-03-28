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
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "PierreBeucher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iQFw3m7dpAii/Nc1UQ/ZXTuHvj5vGsp3SOqd14uHUpc=";
  };

  cargoHash = "sha256-mQ7Vm80S4FALWiEsV+68pNrah36aYu7PediRlJUXLAk=";

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
