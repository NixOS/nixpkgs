{ stdenv }:

with stdenv.lib;

{ outputs, ... } @ args:

stdenv.mkDerivation (args // {

  #postPhases = [ "fixupOutputsPhase" ] ++ args.postPhases or [];

  preHook =
    ''
      ${optionalString (elem "bin" outputs) ''
        configureFlags="--bindir=$bin/bin --mandir=$bin/share/man $configureFlags"
      ''}
      ${optionalString (elem "lib" outputs) ''
        configureFlags="--libdir=$lib/lib $configureFlags"
      ''}
      ${optionalString (elem "dev" outputs) ''
        configureFlags="--includedir=$dev/include $configureFlags"
        installFlags="pkgconfigdir=$dev/lib/pkgconfig m4datadir=$dev/share/aclocal aclocaldir=$dev/share/aclocal $installFlags"
      ''}
    '';

  preFixup =
    ''
      runHook preFixupOutputs

      if [ -n "$doc" ]; then
        for i in share/doc share/gtk-doc; do
          if [ -e $out/$i ]; then
            mkdir -p $doc/$i
            mv $out/$i/* $doc/$i/
            rmdir $out/$i
          fi
        done
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
