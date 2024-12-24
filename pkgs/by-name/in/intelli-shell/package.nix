{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  sqlite,
  zlib,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "intelli-shell";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "lasantosr";
    repo = "intelli-shell";
    rev = "v${version}";
    hash = "sha256-D7hB1vKi54L7hU3TqTvzxXIr6XohfYLUTidR6wFJmfo=";
  };

  cargoHash = "sha256-OAQpOxPWg27kIeM37S5SEGFHMwJPvTGREtG9rd6+lDM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
      sqlite
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Like IntelliSense, but for shells";
    homepage = "https://github.com/lasantosr/intelli-shell";
    license = licenses.asl20;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "intelli-shell";
  };
}
