{stdenv, fetchurl, jre}:

let
  version = "5.0.265.0";
in
  stdenv.mkDerivation {
    name = "geogebra-${version}";
    inherit version;

    src = fetchurl {
      url = "http://download.geogebra.org/installers/5.0/GeoGebra-Linux-Portable-${version}.tar.bz2";
      sha256 = "74e5abfa098ee0fc464cd391cd3ef6db474ff25e8ea4fbcd82c4b4b5d3d5c459";
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
      license = with stdenv.lib.licenses; [gpl3  cc-by-nc-sa-30 geogebra];
      platforms = stdenv.lib.platforms.all;
    };
  }
