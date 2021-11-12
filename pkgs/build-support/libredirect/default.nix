{ stdenv, lib, coreutils }:

stdenv.mkDerivation rec {
  pname = "libredirect";
  version = "0";

  unpackPhase = ''
    cp ${./libredirect.c} libredirect.c
    cp ${./test.c} test.c
  '';

  libName = "libredirect" + stdenv.targetPlatform.extensions.sharedLibrary;

  outputs = ["out" "hook"];

  buildPhase = ''
    runHook preBuild

    $CC -Wall -std=c99 -O3 -fPIC -ldl -shared \
      ${lib.optionalString stdenv.isDarwin "-Wl,-install_name,$out/lib/$libName"} \
      -o "$libName" \
      libredirect.c

    if [ -n "$doInstallCheck" ]; then
      $CC -Wall -std=c99 -O3 test.c -o test
    fi

    runHook postBuild
  '';

  # We want to retain debugging info to be able to use GDB on libredirect.so
  # to more easily investigate which function overrides are missing or why
  # existing ones do not have the intended effect.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -vD "$libName" "$out/lib/$libName"

    # Provide a setup hook that injects our library into every process.
    mkdir -p "$hook/nix-support"
    cat <<SETUP_HOOK > "$hook/nix-support/setup-hook"
    ${if stdenv.isDarwin then ''
    export DYLD_INSERT_LIBRARIES="$out/lib/$libName"
    '' else ''
    export LD_PRELOAD="$out/lib/$libName"
    ''}
    SETUP_HOOK

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    (
      source "$hook/nix-support/setup-hook"
      NIX_REDIRECTS="/foo/bar/test=${coreutils}/bin/true" ./test
    )
  '';

  meta = with lib; {
    platforms = platforms.unix;
    description = "An LD_PRELOAD library to intercept and rewrite the paths in glibc calls";
    longDescription = ''
      libredirect is an LD_PRELOAD library to intercept and rewrite the paths in
      glibc calls based on the value of $NIX_REDIRECTS, a colon-separated list
      of path prefixes to be rewritten, e.g. "/src=/dst:/usr/=/nix/store/".
    '';
  };
}
