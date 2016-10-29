{ stdenv, libsodium, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db62, boost
, zlib, gtest, gmock, miniupnpc, callPackage, gmp, qt4, utillinux, protobuf, qrencode, libevent
, withGui }:

let snark = callPackage ./snark { inherit boost openssl; };
in
with stdenv.lib;
stdenv.mkDerivation rec{

  name = "zcash" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "str4d";
    repo  = "zcash";
    rev = "ed03ab9bb1d2a70e0ceb8e66ede86cda0e714b9b";
    sha256 = "072nlqf3gkfnx22kba37las2np45nqk1223gg9y0b7hizy3xwy5l";
  };

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig gtest gmock gmp snark autoreconfHook openssl db62 boost zlib
                  miniupnpc protobuf libevent snark libsodium]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "LIBSNARK_INCDIR=${snark}/include/libsnark"
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
    homepage = "https://z.cash/";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
