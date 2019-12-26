{ stdenv, libsodium, fetchFromGitHub, wget, pkgconfig, autoreconfHook, openssl, db62, boost17x
, zlib, gtest, gmock, callPackage, gmp, qt4, utillinux, protobuf, qrencode, libevent }:

let librustzcash = callPackage ./librustzcash {};
in
with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "zcash";
  version = "2.1.0-1";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    sha256 = "05bnn4lxrrcv1ha3jdfrgwg4ar576161n3j9d4gpc14ww3zgf9vz";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gtest gmock gmp openssl wget db62 boost17x zlib
                  protobuf libevent libsodium librustzcash ]
                  ++ optionals stdenv.isLinux [ utillinux ];

  configureFlags = [ "--with-boost-libdir=${boost17x.out}/lib" ];

  patchPhase = ''
    sed -i"" 's,-fvisibility=hidden,,g'            src/Makefile.am
  '';

  postInstall = ''
    cp zcutil/fetch-params.sh $out/bin/zcash-fetch-params
  '';

  meta = {
    description = "Peer-to-peer, anonymous electronic cash system";
    homepage = https://z.cash/;
    maintainers = with maintainers; [ rht tkerber ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
