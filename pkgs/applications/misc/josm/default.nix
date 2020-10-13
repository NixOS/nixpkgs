{ stdenv, fetchurl, fetchsvn, makeWrapper, unzip, jre, libXxf86vm }:
let
  pname = "josm";
  version = "17084";
  srcs = {
    jar = fetchurl {
      url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
      sha256 = "0avzpzmvv371jpbph9xpq0ia2nikha2aib9v10hr2f9q7vka9zx4";
    };
    macosx = fetchurl {
      url = "https://josm.openstreetmap.de/download/macosx/josm-macosx-${version}.zip";
      sha256 = "1vd2r4sshjpd6ic460cdil75skrm6f6q48lm6n3g1ywkn4mx63p1";
    };
    pkg = fetchsvn {
      url = "https://josm.openstreetmap.de/svn/trunk/native/linux/tested";
      rev = version;
      sha256 = "0ybjca6dhnbwl3xqwrc91c444fzs1zrlnz7qr3l79s1vll9r4qd1";
    };
  };
in
stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;

  buildInputs = stdenv.lib.optionals (!stdenv.isDarwin) [ jre makeWrapper ];

  installPhase =
    if stdenv.isDarwin then ''
      mkdir -p $out/Applications
      ${unzip}/bin/unzip ${srcs.macosx} 'JOSM.app/*' -d $out/Applications
    '' else ''
      install -Dm644 ${srcs.jar} $out/share/josm/josm.jar
      cp -R ${srcs.pkg}/usr/share $out

      # Add libXxf86vm to path because it is needed by at least Kendzi3D plugin
      makeWrapper ${jre}/bin/java $out/bin/josm \
        --add-flags "-Djosm.restart=true -Djava.net.useSystemProxies=true" \
        --add-flags "-jar $out/share/josm/josm.jar" \
        --prefix LD_LIBRARY_PATH ":" '${libXxf86vm}/lib'
    '';

  meta = with stdenv.lib; {
    description = "An extensible editor for OpenStreetMap";
    homepage = "https://josm.openstreetmap.de/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rycee sikmir ];
    platforms = platforms.all;
  };
}
