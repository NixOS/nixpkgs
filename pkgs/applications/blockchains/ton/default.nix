{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  git,
  pkg-config,
  gperf,
  libmicrohttpd,
  libsodium,
  lz4,
  openssl,
  readline,
  secp256k1,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "ton";
  version = "2024.04";

  src = fetchFromGitHub {
    owner = "ton-blockchain";
    repo = "ton";
    rev = "v${version}";
    hash = "sha256-hh8D4IZX6RS/RXdhVONhgetqp89kpTC2IwDQ2KHdKsE=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs = [
    gperf
    libmicrohttpd
    libsodium
    lz4
    openssl
    readline
    secp256k1
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    # The build fails on darwin as:
    #   error: aligned allocation function of type 'void *(std::size_t, std::align_val_t)' is only available on macOS 10.13 or newer
    broken = stdenv.isDarwin;
    description = "A fully decentralized layer-1 blockchain designed by Telegram";
    homepage = "https://ton.org/";
    changelog = "https://github.com/ton-blockchain/ton/blob/v${version}/Changelog.md";
    license = licenses.lgpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
