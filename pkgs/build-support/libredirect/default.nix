{ lib, stdenv, bintools-unwrapped, llvmPackages_13, coreutils }:

if stdenv.hostPlatform.isStatic
then throw ''
  libredirect is not available on static builds.

  Please fix your derivation to not depend on libredirect on static
  builds, using something like following:

    nativeBuildInputs =
      lib.optional (!stdenv.buildPlatform.isStatic) libredirect;

  and disable tests as necessary, although fixing tests to work without
  libredirect is even better.

  libredirect uses LD_PRELOAD feature of dynamic loader and does not
  work on static builds where dynamic loader is not used.
  ''
else stdenv.mkDerivation rec {
  pname = "libredirect";
  version = "0";

  unpackPhase = ''
    cp ${./libredirect.c} libredirect.c
    cp ${./test.c} test.c
  '';

  outputs = ["out" "hook"];

  libName = "libredirect" + stdenv.targetPlatform.extensions.sharedLibrary;

  buildPhase = ''
    runHook preBuild

    ${if stdenv.isDarwin && stdenv.isAarch64 then ''
    # We need the unwrapped binutils and clang:
    # We also want to build a fat library with x86_64, arm64, arm64e in there.
    # Because we use the unwrapped tools, we need to provide -isystem for headers
    # and the library search directory for libdl.
    # We can't build this on x86_64, because the libSystem we point to doesn't
    # like arm64(e).
    PATH=${bintools-unwrapped}/bin:${llvmPackages_13.clang-unwrapped}/bin:$PATH \
      clang -arch x86_64 -arch arm64 -arch arm64e \
      -isystem ${llvmPackages_13.clang.libc}/include \
      -isystem ${llvmPackages_13.libclang.lib}/lib/clang/*/include \
      -L${llvmPackages_13.clang.libc}/lib \
      -Wl,-install_name,$libName \
      -Wall -std=c99 -O3 -fPIC libredirect.c \
      -ldl -shared -o "$libName"
    '' else if stdenv.isDarwin then ''
    $CC -Wall -std=c99 -O3 -fPIC libredirect.c \
      -Wl,-install_name,$out/lib/$libName \
      -ldl -shared -o "$libName"
    '' else ''
    $CC -Wall -std=c99 -O3 -fPIC libredirect.c \
      -ldl -shared -o "$libName"
    ''}

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

  '' + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # dylib will be rejected unless dylib rpath gets explictly set
    install_name_tool \
      -change $libName $out/lib/$libName \
      $out/lib/$libName
  '' + ''
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
