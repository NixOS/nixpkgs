{ stdenv }:

with stdenv.lib;

{ outputs, ... } @ args:

stdenv.mkDerivation (args // {

  configureFlags =
    optionals (elem "bin" outputs)
      [ "--bindir=$(bin)/bin" "--mandir=$(bin)/share/man" ]
    ++ optional (elem "dev" outputs)
      "--includedir=$(dev)/include";

  installFlags =
    optionals (elem "dev" outputs)
      [ "pkgconfigdir=$(dev)/lib/pkgconfig" "m4datadir=$(dev)/share/aclocal" ];

  postInstall =
    ''
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
        echo "$propagatedBuildNativeInputs $out" > "$dev/nix-support/propagated-build-native-inputs"
        propagatedBuildNativeInputs=
      fi
    ''; # */

})
