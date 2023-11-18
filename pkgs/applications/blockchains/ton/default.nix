{ lib
, stdenv
, fetchFromGitHub
, cmake
, git
, pkg-config
, gperf
, libmicrohttpd
, openssl
, readline
, zlib
}:

stdenv.mkDerivation rec {
  pname = "ton";
  version = "2023.06";

  src = fetchFromGitHub {
    owner = "ton-blockchain";
    repo = "ton";
    rev = "v${version}";
    sha256 = "sha256-mDYuOokCGS1sDP6fHDXhGboDjn4JeyA5ea4/6RRt9x4=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs = [
    gperf
    libmicrohttpd
    openssl
    readline
    zlib
  ];

  meta = with lib; {
    description = "A fully decentralized layer-1 blockchain designed by Telegram";
    homepage = "https://ton.org/";
    changelog = "https://github.com/ton-blockchain/ton/blob/v${version}/Changelog.md";
    license = licenses.lgpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
