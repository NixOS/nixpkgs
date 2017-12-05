{ stdenv, libsodium, fetchFromGitHub, wget, pkgconfig, autoreconfHook, openssl, db62, boost
, zlib, gtest, gmock, miniupnpc, callPackage, gmp, qt4, utillinux, protobuf, qrencode, libevent
, withGui }:

let libsnark     = callPackage ./libsnark { inherit boost openssl; };
    librustzcash = callPackage ./librustzcash {};
in
with stdenv.lib;
stdenv.mkDerivation rec{

  name = "zcash" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "f630519d865ce22a6cf72a29785f2a876902f8e1";
    sha256 = "1zjxg3dp0amjfs67469yp9b223v9hx29lkxid9wz2ivxj3paq7bv";
  };

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig gtest gmock gmp libsnark autoreconfHook openssl wget db62 boost zlib
                  miniupnpc protobuf libevent libsodium librustzcash ]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "LIBSNARK_INCDIR=${libsnark}/include/libsnark"
                     "--with-boost-libdir=${boost.out}/lib"
                   ] ++ optionals withGui [ "--with-gui=qt4" ];

  patchPhase = ''
    sed -i"" '/^\[LIBSNARK_INCDIR/d'               configure.ac
    sed -i"" 's,-lboost_system-mt,-lboost_system,' configure.ac
    sed -i"" 's,-fvisibility=hidden,,g'            src/Makefile.am
  '';

  postInstall = ''
    cp zcutil/fetch-params.sh $out/bin/zcash-fetch-params
  '';

  meta = {
    description = "Peer-to-peer, anonymous electronic cash system";
    homepage = https://z.cash/;
    maintainers = with maintainers; [ rht ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
