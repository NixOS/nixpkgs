{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "btor2tools";
  version = "1.0.0-pre_${src.rev}";

  src = fetchFromGitHub {
    owner  = "boolector";
    repo   = "btor2tools";
    rev    = "9831f9909fb283752a3d6d60d43613173bd8af42";
    sha256 = "0mfqmkgvyw8fa2c09kww107dmk180ch1hp98r5kv41vnc04iqb0s";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out $dev/include/btor2parser/ $lib/lib

    cp -vr bin $out
    cp -v  ../src/btor2parser/btor2parser.h $dev/include/btor2parser
    cp -v  lib/libbtor2parser.* $lib/lib
  '';

  outputs = [ "out" "dev" "lib" ];

  meta = with stdenv.lib; {
    description = "A generic parser and tool package for the BTOR2 format";
    homepage    = "https://github.com/Boolector/btor2tools";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
