{ lib
, stdenv
, fetchFromGitHub
, cmake
, git
, gperf
, libmicrohttpd
, openssl
, readline
, zlib
}:

stdenv.mkDerivation rec {
  pname = "ton";
  version = "2023.01";

  src = fetchFromGitHub {
    owner = "ton-blockchain";
    repo = "ton";
    rev = "v${version}";
    sha256 = "sha256-wb96vh0YcTBFE8EzBItdTf88cvRMLW2XxcGJpNetOi8=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # without this fails on aarch64-darwin with clang-11: error: the clang compiler does not support '-mcpu=apple-m1'
    substituteInPlace CMakeLists.txt \
      --replace 'set(TON_ARCH "apple-m1")' ""
  '';

  nativeBuildInputs = [
    cmake
    git
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
    license = licenses.lgpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
