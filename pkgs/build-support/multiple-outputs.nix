{ stdenv }:

with stdenv.lib;

{ outputs, ... } @ args:

stdenv.mkDerivation (args // {

  configureFlags =
    optionals (elem "bin" outputs)
      [ "--bindir=$(bin)/bin" "--mandir=$(bin)/share/man" ]
    ++ optionals (elem "lib" outputs)
      [ "--libdir=$(lib)/lib" ]
    ++ optional (elem "dev" outputs)
      "--includedir=$(dev)/include"
    ++ [ (toString args.configureFlags or []) ];

  installFlags =
    optionals (elem "dev" outputs)
      [ "pkgconfigdir=$(dev)/lib/pkgconfig" "m4datadir=$(dev)/share/aclocal" "aclocaldir=$(dev)/share/aclocal" ]
    ++ [ (toString args.installFlags or []) ];

  #postPhases = [ "fixupOutputsPhase" ] ++ args.postPhases or [];

  preFixup =
    ''
      runHook preFixupOutputs

      if [ -n "$doc" -a -e $out/share/doc ]; then
        mkdir -p $doc/share/doc
        mv $out/share/doc/* $doc/share/doc
        rmdir $out/share/doc
        rmdir --ignore-fail-on-non-empty $out/share
      fi

      if [ -n "$dev" ]; then
        mkdir -p "$dev/nix-support"
        if [ -n "$propagatedBuildInputs" ]; then
          echo "$propagatedBuildInputs" > "$dev/nix-support/propagated-build-inputs"
          propagatedBuildInputs=
        fi
        echo "$out $lib $propagatedBuildNativeInputs" > "$dev/nix-support/propagated-build-native-inputs"
        propagatedBuildNativeInputs=
      elif [ -n "$out" ]; then
        propagatedBuildNativeInputs="$lib $propagatedBuildNativeInputs"
      fi

      for i in $bin $lib; do
        prefix="$i" stripDirs "lib lib64 libexec bin sbin" "''${stripDebugFlags:--S}"
        prefix="$i" patchELF
        patchShebangs "$i"
      done

      runHook postFixupOutputs
    ''; # */

})
