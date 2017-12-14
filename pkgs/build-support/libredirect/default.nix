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
    description = "An LD_PRELOAD library to intercept and rewrite the paths in glibc calls";
    longDescription = ''
      libredirect is an LD_PRELOAD library to intercept and rewrite the paths in
      glibc calls based on the value of $NIX_REDIRECTS, a colon-separated list
      of path prefixes to be rewritten, e.g. "/src=/dst:/usr/=/nix/store/".
    '';
  };
}
