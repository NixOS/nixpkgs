{
  stdenv,
  fetchFromGitHub,
  lib,
  rustPlatform,
  Security,
  curl,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "snarkos";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "ProvableHQ";
    repo = "snarkOS";
    tag = "v${version}";
    hash = "sha256-t9WgACgsn+JuIVFVmcFPzGPGOChfFGnUKVU+pJvxHtQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6zt1cjYUYoXJjvPaLk8COEjB6fFmyn1al6FNboebxC4=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      curl
    ];

  meta = {
    description = "Decentralized Operating System for Zero-Knowledge Applications";
    homepage = "https://github.com/provableHQ/snarkOS";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
    mainProgram = "snarkos";
  };
}
