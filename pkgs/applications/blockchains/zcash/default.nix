{ stdenv, libsodium, fetchFromGitHub, wget, pkgconfig, autoreconfHook, openssl, db62, boost
, zlib, gtest, gmock, callPackage, gmp, qt4, utillinux, protobuf, qrencode, libevent
, libsnark, withGui }:

let librustzcash = callPackage ./librustzcash {};
in
with stdenv.lib;
stdenv.mkDerivation rec {

  name = "zcash" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    sha256 = "05y7wxs66anxr5akbf05r36mmjfzqpwawn6vyh3jhpva51hzzzyz";
  };

  # Dependencies are underspecified: "make -C src gtest/zcash_gtest-test_merkletree.o"
  # fails with "fatal error: test/data/merkle_roots.json.h: No such file or directory"
  enableParallelBuilding = false;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gtest gmock gmp openssl wget db62 boost zlib
                  protobuf libevent libsodium librustzcash libsnark ]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib"
                   ] ++ optionals withGui [ "--with-gui=qt4" ];

  patchPhase = ''
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
    platforms = platforms.linux;
  };
}
