{ stdenv }:

stdenv.mkDerivation {
  name = "libredirect-0";

  unpackPhase = "cp ${./libredirect.c} libredirect.c";

  shlibext = stdenv.targetPlatform.extensions.sharedLibrary;

  buildPhase = ''
    $CC -Wall -std=c99 -O3 -shared libredirect.c \
      -o "libredirect$shlibext" -fPIC -ldl
  '';

  installPhase = ''
    install -vD "libredirect$shlibext" "$out/lib/libredirect$shlibext"
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
    description = "An LD_PRELOAD library to intercept and rewrite the paths in glibc calls";
    longDescription = ''
      libredirect is an LD_PRELOAD library to intercept and rewrite the paths in
      glibc calls based on the value of $NIX_REDIRECTS, a colon-separated list
      of path prefixes to be rewritten, e.g. "/src=/dst:/usr/=/nix/store/".
    '';
  };
}
