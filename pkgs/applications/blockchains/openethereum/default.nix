{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, openssl
, pkg-config
, stdenv
, systemd
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "openethereum";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "openethereum";
    repo = "openethereum";
    rev = "v${version}";
    sha256 = "sha256-PpRRoufuZ9fXbLonMAo6qaA/jtJZXW98uM0BEXdJ2oU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "app_dirs-1.2.1" = "sha256-zn9/b6VUuQ4U7KpN95hWumaKUg+xUdyEBRBngWhHuqA=";
      "bn-0.4.4" = "sha256-SdlIZwN2AVrq8Ezz0AeLRc+4G/YpqwCpFPS8QqLQ0yU=";
      "ctrlc-1.1.1" = "sha256-AqJR2B4PnR/fc7N+t2L0zZQ1fYy1GouGKkzupQw8uRQ=";
      "eth-secp256k1-0.5.7" = "sha256-2ZwY2cODE7AVJ2WBTuHZ01dZXegeNmZHKRUXVemLs1A=";
      "eth_pairings-0.6.0" = "sha256-2qLyuOArJOH029JKXuyB67p9gggsTRpavW1AO4O93L4=";
      "ethabi-11.0.0" = "sha256-QVlwdv5iHOhp98rwSZC6b+YFLTdlq3va6YzAZzm8q8Y=";
      "reth-util-0.1.0" = "sha256-3W8ESWCqEtDuoY2YhB1YVlQXs91XWfuAN2feuv0u6yU=";
    };
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isLinux [ systemd ]
    ++ lib.optionals stdenv.isDarwin [ darwin.Security ];

  buildFeatures = [ "final" ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Exclude some tests that don't work in the sandbox
  # - Nat test requires network access
  checkFlags = [ "--skip" "configuration::tests::should_resolve_external_nat_hosts" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Fast, light, robust Ethereum implementation";
    homepage = "http://parity.io/ethereum";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akru ];
    platforms = lib.platforms.unix;
  };
}
