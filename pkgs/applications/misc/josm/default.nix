{ stdenv, fetchurl, fetchsvn, makeWrapper, unzip, jre, libXxf86vm }:
let
  pname = "josm";
  version = "17428";
  srcs = {
    jar = fetchurl {
      url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
      sha256 = "0fhnq0836jp72br808hhw1ki70zc9wqcwfhnizb8pzjvs4wgx36w";
    };
    macosx = fetchurl {
      url = "https://josm.openstreetmap.de/download/macosx/josm-macosx-${version}.zip";
      sha256 = "126yy6y7mkpqzkrkqkzzn3mwnl1yjkmd5k895k7mmk2inmcsvqgm";
    };
    pkg = fetchsvn {
      url = "https://josm.openstreetmap.de/svn/trunk/native/linux/tested";
      rev = version;
      sha256 = "198kq490y5wzxz0a5prb9anykq6dzg0imxfkchsas233inbzggql";
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
    changelog = "https://josm.openstreetmap.de/wiki/Changelog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rycee sikmir ];
    platforms = platforms.all;
  };
}
