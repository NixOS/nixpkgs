{ stdenv, libsodium, fetchFromGitHub, wget, pkgconfig, autoreconfHook, openssl, db62, boost17x
, zlib, gtest, gmock, callPackage, gmp, qt4, utillinux, protobuf, qrencode, libevent }:

let librustzcash = callPackage ./librustzcash {};
in
with stdenv.lib;
stdenv.mkDerivation rec {

  pname = "zcash";
  version = "2.1.1-1";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    sha256 = "1g5zlfzfp31my8w8nlg5fncpr2y95iv9fm04x57sjb93rgmjdh5n";
  };

  patchPhase = ''
    sed -i"" 's,-fvisibility=hidden,,g'            src/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gtest gmock gmp openssl wget db62 boost17x zlib
                  protobuf libevent libsodium librustzcash ]
                  ++ optionals stdenv.isLinux [ utillinux ];

  configureFlags = [ "--with-boost-libdir=${boost17x.out}/lib" ];

  postInstall = ''
    cp zcutil/fetch-params.sh $out/bin/zcash-fetch-params
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Peer-to-peer, anonymous electronic cash system";
    homepage = "https://z.cash/";
    maintainers = with maintainers; [ rht tkerber ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
