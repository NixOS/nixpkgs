# When updating this package please check that all other versions of Nim
# evaluate because they reuse definitions from the latest compiler.
{
  lib,
  stdenv,
  buildPackages,
  darwin,
  makeWrapper,
  openssl,
  pcre,
  nim-unwrapped-2_2 ? buildPackages.nim-unwrapped-2_2,
}:

let
  wrapNim =
    { nimUnwrapped, patches }:
    let
      targetPlatformConfig = stdenv.targetPlatform.config;
    in
    stdenv.mkDerivation (finalAttrs: {
      name = "${targetPlatformConfig}-nim-wrapper-${nimUnwrapped.version}";
      inherit (nimUnwrapped) version;
      preferLocalBuild = true;
      strictDeps = true;

      nativeBuildInputs = [ makeWrapper ];

      # Needed for any nim package that uses the standard library's
      # 'std/sysrand' module.

      inherit patches;

      unpackPhase = ''
        runHook preUnpack
        tar xf ${nimUnwrapped.src} nim-$version/config
        cd nim-$version
        runHook postUnpack
      '';

      dontConfigure = true;

      buildPhase =
        # Configure the Nim compiler to use $CC and $CXX as backends
        # The compiler is configured by two configuration files, each with
        # a different DSL. The order of evaluation matters and that order
        # is not documented, so duplicate the configuration across both files.
        ''
          runHook preBuild
          cat >> config/config.nims << WTF

          switch("os", "${nimUnwrapped.passthru.nimTarget.os}")
          switch("cpu", "${nimUnwrapped.passthru.nimTarget.cpu}")
          switch("define", "nixbuild")

          # Configure the compiler using the $CC set by Nix at build time
          import strutils
          let cc = getEnv"CC"
          if cc.contains("gcc"):
            switch("cc", "gcc")
          elif cc.contains("clang"):
            switch("cc", "clang")
          WTF

          mv config/nim.cfg config/nim.cfg.old
          cat > config/nim.cfg << WTF
          os = "${nimUnwrapped.passthru.nimTarget.os}"
          cpu =  "${nimUnwrapped.passthru.nimTarget.cpu}"
          define:"nixbuild"
          WTF

          cat >> config/nim.cfg < config/nim.cfg.old
          rm config/nim.cfg.old

          cat >> config/nim.cfg << WTF

          clang.cpp.exe %= "\$CXX"
          clang.cpp.linkerexe %= "\$CXX"
          clang.exe %= "\$CC"
          clang.linkerexe %= "\$CC"
          gcc.cpp.exe %= "\$CXX"
          gcc.cpp.linkerexe %= "\$CXX"
          gcc.exe %= "\$CC"
          gcc.linkerexe %= "\$CC"
          WTF

          runHook postBuild
        '';

      wrapperArgs = lib.optionals (!(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) [
        "--prefix PATH : ${lib.makeBinPath [ buildPackages.gdb ]}:${placeholder "out"}/bin"
        # Used by nim-gdb

        "--prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            openssl
            pcre
          ]
        }"
        # These libraries may be referred to by the standard library.
        # This is broken for cross-compilation because the package
        # set will be shifted back by nativeBuildInputs.

        "--set NIM_CONFIG_PATH ${placeholder "out"}/etc/nim"
        # Use the custom configuration
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/etc

        cp -r config $out/etc/nim

        for binpath in ${nimUnwrapped}/bin/nim?*; do
          local binname=`basename $binpath`
          makeWrapper \
            $binpath $out/bin/${targetPlatformConfig}-$binname \
            $wrapperArgs
          ln -s $out/bin/${targetPlatformConfig}-$binname $out/bin/$binname
        done

        makeWrapper \
          ${nimUnwrapped}/nim/bin/nim $out/bin/${targetPlatformConfig}-nim \
          --set-default CC $(command -v $CC) \
          --set-default CXX $(command -v $CXX) \
          $wrapperArgs
        ln -s $out/bin/${targetPlatformConfig}-nim $out/bin/nim

        makeWrapper \
          ${nimUnwrapped}/bin/testament $out/bin/${targetPlatformConfig}-testament \
          $wrapperArgs
        ln -s $out/bin/${targetPlatformConfig}-testament $out/bin/testament

      ''
      + ''
        runHook postInstall
      '';

      passthru = nimUnwrapped.passthru // {
        inherit wrapNim;
        nim = nimUnwrapped;
      };

      meta = nimUnwrapped.meta // {
        description = nimUnwrapped.meta.description + " (${targetPlatformConfig} wrapper)";
        platforms = with lib.platforms; unix ++ genode ++ windows;
      };
    });
in
wrapNim {
  nimUnwrapped = nim-unwrapped-2_2;
  patches = [ ./nim2.cfg.patch ];
}
