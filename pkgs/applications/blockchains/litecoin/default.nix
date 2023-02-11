{ lib, stdenv, mkDerivation, fetchFromGitHub
, pkg-config, autoreconfHook
, openssl, db48, boost, zlib, miniupnpc
, glib, protobuf, util-linux, qrencode
, AppKit
, withGui ? true, libevent
, qtbase, qttools
, zeromq
, fmt
}:

mkDerivation rec {
  pname = "litecoin" + lib.optionalString (!withGui) "d";
  version = "0.21.2.1";

  src = fetchFromGitHub {
    owner = "litecoin-project";
    repo = "litecoin";
    rev = "v${version}";
    sha256 = "sha256-WJFdac5hGrHy9o3HzjS91zH+4EtJY7kUJAQK+aZaEyo=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib zeromq fmt
                  miniupnpc glib protobuf util-linux libevent ]
                  ++ lib.optionals stdenv.isDarwin [ AppKit ]
                  ++ lib.optionals withGui [ qtbase qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                   ++ lib.optionals withGui [
                      "--with-gui=qt5"
                      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin" ];

  enableParallelBuilding = true;

  doCheck = true;
  checkPhase = ''
    ./src/test/test_litecoin
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "A lite version of Bitcoin using scrypt as a proof-of-work algorithm";
    longDescription= ''
      Litecoin is a peer-to-peer Internet currency that enables instant payments
      to anyone in the world. It is based on the Bitcoin protocol but differs
      from Bitcoin in that it can be efficiently mined with consumer-grade hardware.
      Litecoin provides faster transaction confirmations (2.5 minutes on average)
      and uses a memory-hard, scrypt-based mining proof-of-work algorithm to target
      the regular computers and GPUs most people already have.
      The Litecoin network is scheduled to produce 84 million currency units.
    '';
    homepage = "https://litecoin.org/";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
