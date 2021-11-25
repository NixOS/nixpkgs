{ stdenv, lib }:

stdenv.mkDerivation rec {
  pname = "libredirect-self";
  version = "0";

  unpackPhase = ''
    cp ${./libredirect-self.c} libredirect-self.c
    cp ${./test.c} test.c
  '';

  libName = "libredirect-self" + stdenv.targetPlatform.extensions.sharedLibrary;

  outputs = ["out" "hook"];

  buildPhase = ''
    runHook preBuild

    $CC -Wall -std=c99 -O3 -fPIC -ldl -shared \
      ${lib.optionalString stdenv.isDarwin "-Wl,-install_name,$out/lib/$libName"} \
      -o "$libName" \
      libredirect-self.c

    if [ -n "$doInstallCheck" ]; then
      $CC -Wall -std=c99 -O3 test.c -o test
    fi

    runHook postBuild
  '';

  # We want to retain debugging info to be able to use GDB on libredirect-self.so
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

      declare ori_self_exe="$PWD/test"
      export NIX_TEST_ORI_SELF_EXE="$ori_self_exe"

      # Changed case.
      NIX_TEST_EXP_SELF_EXE="/foo/bar/test" \
      NIX_SELF_REDIRECTS="''${ori_self_exe}=/foo/bar/test" \
        ./test

      # Unchanged case no preload.
      NIX_TEST_EXP_SELF_EXE="$ori_self_exe" \
        ./test

      # Unchanged case with preload.
      NIX_TEST_EXP_SELF_EXE="$ori_self_exe" \
      NIX_SELF_REDIRECTS="''${ori_self_exe}-does-not-exist=/foo/bar/test" \
        ./test
    )
  '';

  meta = with lib; {
    platforms = platforms.unix;
    description = "An LD_PRELOAD library to change perceived '/proc/self/exe'";
    longDescription = ''
      libredirect-self is an LD_PRELOAD library to change the '/proc/self/exe'
      value (linux) observed by running executables of the process based on the value
      of $NIX_SELF_REDIRECTS, a colon-separated list of path prefixes to be rewritten,
      e.g. "/ori/a=/new/a:/ori/b=/new/b".
    '';
  };
}
