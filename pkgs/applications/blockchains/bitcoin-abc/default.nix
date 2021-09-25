{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, cmake
, openssl
, db53
, boost
, zlib
, miniupnpc
, qtbase ? null
, qttools ? null
, util-linux
, protobuf
, qrencode
, libevent
, withGui
, python3
, jemalloc
, zeromq4
}:

mkDerivation rec {
  pname = "bitcoin" + lib.optionalString (!withGui) "d" + "-abc";
  version = "0.21.13";

  src = fetchFromGitHub {
    owner = "bitcoin-ABC";
    repo = "bitcoin-abc";
    rev = "v${version}";
    sha256 = "1x8xcdi1vcskggk9bqkwr3ah4vi9b7sj2h8hf7spac6dvz8lmzav";
  };

  patches = [ ./fix-bitcoin-qt-build.patch ];

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    openssl
    db53
    boost
    zlib
    python3
    jemalloc
    zeromq4
    miniupnpc
    util-linux
    protobuf
    libevent
  ] ++ lib.optionals withGui [ qtbase qttools qrencode ];

  cmakeFlags = lib.optionals (!withGui) [
    "-DBUILD_BITCOIN_QT=OFF"
  ];

  # many of the generated scripts lack execute permissions
  postConfigure = ''
    find ./. -type f -iname "*.sh" -exec chmod +x {} \;
  '';

  meta = with lib; {
    description = "Peer-to-peer electronic cash system (Cash client)";
    longDescription = ''
      Bitcoin ABC is the name of open source software which enables the use of Bitcoin.
      It is designed to facilite a hard fork to increase Bitcoin's block size limit.
      "ABC" stands for "Adjustable Blocksize Cap".

      Bitcoin ABC is a fork of the Bitcoin Core software project.
    '';
    homepage = "https://bitcoinabc.org/";
    maintainers = with maintainers; [ lassulus ];
    license = licenses.mit;
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}
