{ stdenv, coreutils }:

stdenv.mkDerivation {
  name = "libredirect-0";

  unpackPhase = ''
    cp ${./libredirect.c} libredirect.c
    cp ${./test.c} test.c
  '';

  shlibext = stdenv.targetPlatform.extensions.sharedLibrary;

  buildPhase = ''
    $CC -Wall -std=c99 -O3 -shared libredirect.c \
      -o "libredirect$shlibext" -fPIC -ldl

    if [ -n "$doInstallCheck" ]; then
      $CC -Wall -std=c99 -O3 test.c -o test
    fi
  '';

  installPhase = ''
    install -vD "libredirect$shlibext" "$out/lib/libredirect$shlibext"
  '';

  doInstallCheck = true;

  installCheckPhase = if stdenv.isDarwin then ''
    NIX_REDIRECTS="/foo/bar/test=${coreutils}/bin/true" \
    DYLD_INSERT_LIBRARIES="$out/lib/libredirect$shlibext" \
    DYLD_FORCE_FLAT_NAMESPACE=1 ./test
  '' else ''
    NIX_REDIRECTS="/foo/bar/test=${coreutils}/bin/true" \
    LD_PRELOAD="$out/lib/libredirect$shlibext" ./test
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
