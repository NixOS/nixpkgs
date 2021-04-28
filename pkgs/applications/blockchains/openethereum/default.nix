{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, llvmPackages
, openssl
, pkg-config
, stdenv
, systemd
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "openethereum";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "openethereum";
    repo = "openethereum";
    rev = "v${version}";
    sha256 = "143w0b0ff1s73qzr844l25w90d2y2z0b3w2fr5kkbc1wsnpcq7jp";
  };

  cargoSha256 = "1gm02pcfll362add8a0dcb0sk0mag8z0q23b87yb6fs870bqvhib";

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  nativeBuildInputs = [
    cmake
    llvmPackages.clang
    llvmPackages.libclang
    pkg-config
  ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isLinux [ systemd ]
    ++ lib.optionals stdenv.isDarwin [ darwin.Security ];

  cargoBuildFlags = [ "--features final" ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Exclude some tests that don't work in the sandbox
  # - Nat test requires network access
  checkFlags = "--skip configuration::tests::should_resolve_external_nat_hosts";

  meta = with lib; {
    description = "Fast, light, robust Ethereum implementation";
    homepage = "http://parity.io/ethereum";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akru xrelkd ];
    platforms = lib.platforms.unix;
  };
}
