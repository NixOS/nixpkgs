{stdenv, fetchurl, jre}:

let
  version = "5.0.264.0";
in
  stdenv.mkDerivation {
    name = "geogebra-${version}";
    inherit version;

    src = fetchurl {
      url = "http://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2";
      sha256 = "da96e1c9a10fd066a1814937993809a8c964f6f2ca1660246f823eb0afe5ee52";
    };

    installPhase = ''
      install -dm755 "$out/share/geogebra"
      install "geogebra/"* -t "$out/share/geogebra/"
      mkdir "$out/bin"

      cat <<EOF >"$out/bin/geogebra"
      #! $SHELL
      export GG_PATH="$out/share/geogebra"
      export JAVACMD="${jre}/bin/java"
      exec "\$GG_PATH/geogebra" "\$@"
      EOF

      chmod +x "$out/bin/geogebra"
      '';

    meta = {
      description = "Dynamic mathematics software with graphics, algebra and spreadsheets";
      longDescription = ''
      Dynamic mathematics software for all levels of education that brings
      together geometry, algebra, spreadsheets, graphing, statistics and
      calculus in one easy-to-use package.
      '';
      homepage = https://www.geogebra.org/;
      license = "free";
      platforms = stdenv.lib.platforms.all;
    };
  }
