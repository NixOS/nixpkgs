{ lib, stdenv, cmake, fetchFromGitHub, fetchpatch, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "btor2tools";
  version = "1.0.0-pre_${src.rev}";

  src = fetchFromGitHub {
    owner  = "boolector";
    repo   = "btor2tools";
    rev    = "9831f9909fb283752a3d6d60d43613173bd8af42";
    sha256 = "0mfqmkgvyw8fa2c09kww107dmk180ch1hp98r5kv41vnc04iqb0s";
  };

  patches = [
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/Boolector/btor2tools/commit/037f1fa88fb439dca6f648ad48a3463256d69d8b.patch";
      hash = "sha256-FX1yy9XdUs1tAReOxhEzNHu48DrISzNNMSYoIrhHoFY=";
    })
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  installPhase = ''
    mkdir -p $out $dev/include/btor2parser/ $lib/lib

    cp -vr bin $out
    cp -v  ../src/btor2parser/btor2parser.h $dev/include/btor2parser
    cp -v  lib/libbtor2parser.* $lib/lib
  '';

  outputs = [ "out" "dev" "lib" ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/btorsim contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  meta = with lib; {
    description = "Generic parser and tool package for the BTOR2 format";
    homepage    = "https://github.com/Boolector/btor2tools";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
