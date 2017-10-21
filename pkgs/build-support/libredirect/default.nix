{ stdenv }:

stdenv.mkDerivation {
  name = "libredirect-0";

  unpackPhase = "cp ${./libredirect.c} libredirect.c";

  buildPhase =
    ''
      gcc -Wall -std=c99 -O3 -shared libredirect.c -o libredirect.so -fPIC -ldl
    '';

  installPhase = "mkdir -p $out/lib; cp libredirect.so $out/lib";

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
