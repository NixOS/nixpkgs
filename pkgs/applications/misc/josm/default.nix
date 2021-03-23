{ lib, stdenv, fetchurl, fetchsvn, makeWrapper, unzip, jre, libXxf86vm }:
let
  pname = "josm";
  version = "17560";
  srcs = {
    jar = fetchurl {
      url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
      sha256 = "1ffrbg2d4s2dmc9zy9b4fbsqnp9g0pvp6vnrq7gbsmxh0y23sw56";
    };
    macosx = fetchurl {
      url = "https://josm.openstreetmap.de/download/macosx/josm-macosx-${version}.zip";
      sha256 = "17qrilj20bvzd8ydfjjirpqjrsbqbkxyj4q35q87z9j3pgnd1h71";
    };
    pkg = fetchsvn {
      url = "https://josm.openstreetmap.de/svn/trunk/native/linux/tested";
      rev = version;
      sha256 = "0wmncbi5g3ijn19qvmvwszb2m79wnv4jpdmpjd7332d3qi5rfmwn";
    };
  };
in
stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ jre ];

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

  meta = with lib; {
    description = "An extensible editor for OpenStreetMap";
    homepage = "https://josm.openstreetmap.de/";
    changelog = "https://josm.openstreetmap.de/wiki/Changelog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rycee sikmir ];
    platforms = platforms.all;
  };
}
