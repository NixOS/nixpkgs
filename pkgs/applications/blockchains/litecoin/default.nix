{ lib, stdenv, mkDerivation, fetchFromGitHub, fetchpatch
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
  version = "0.21.2.2";

  src = fetchFromGitHub {
    owner = "litecoin-project";
    repo = "litecoin";
    rev = "v${version}";
    sha256 = "sha256-TuDc47TZOEQA5Lr4DQkEhnO/Szp9h71xPjaBL3jFWuM=";
  };

  patches = [
    (fetchpatch {
      name = "boost1770.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/boost1770.patch?h=litecoin-qt&id=dc75ad854af123f375b5b683be64aa14573170d7";
      hash = "sha256-PTkYQRA8n5a9yR2AvpzH5natsXT2W6Xjo0ONCPJx78k=";
    })

    # Fix gcc-13 build by adding missing headers:
    #   https://github.com/litecoin-project/litecoin/pull/929
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/litecoin-project/litecoin/commit/6d1adb19aa79a8e8e140582759515bbd76816aa0.patch";
      hash = "sha256-1y4Iz2plMw5HMAjl9x50QQpYrYaUd2WKrrAcUnQmlBY=";
    })
  ];

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
