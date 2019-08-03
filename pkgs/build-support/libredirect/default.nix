{ stdenv, lib, coreutils }:

stdenv.mkDerivation {
  name = "libredirect-0";

  unpackPhase = ''
    cp ${./libredirect.c} libredirect.c
    cp ${./test.c} test.c
  '';

  libName = "libredirect" + stdenv.targetPlatform.extensions.sharedLibrary;

  outputs = ["out" "hook"];

  buildPhase = ''
    $CC -Wall -std=c99 -O3 -fPIC -ldl -shared \
      ${lib.optionalString stdenv.isDarwin "-Wl,-install_name,$out/lib/$libName"} \
      -o "$libName" \
      libredirect.c

    if [ -n "$doInstallCheck" ]; then
      $CC -Wall -std=c99 -O3 test.c -o test
    fi
  '';

  installPhase = ''
    install -vD "$libName" "$out/lib/$libName"

    mkdir -p "$hook/nix-support"
    cat <<SETUP_HOOK > "$hook/nix-support/setup-hook"
    ${if stdenv.isDarwin then ''
    export DYLD_INSERT_LIBRARIES="$out/lib/$libName"
    export DYLD_FORCE_FLAT_NAMESPACE=1
    '' else ''
    export LD_PRELOAD="$out/lib/$libName"
    ''}
    SETUP_HOOK
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    (
      source "$hook/nix-support/setup-hook"
      NIX_REDIRECTS="/foo/bar/test=${coreutils}/bin/true" ./test
    )
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
