{ lib, stdenv, fetchurl, fetchsvn, makeWrapper, unzip, jre, libXxf86vm
, extraJavaOpts ? "-Djosm.restart=true -Djava.net.useSystemProxies=true"
}:
let
  pname = "josm";
  version = "18789";
  srcs = {
    jar = fetchurl {
      url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
      hash = "sha256-0NuCdGqDNY+UCXv9AhX4oT0WJbxMc5ghkL0YvqVWXOs=";
    };
    macosx = fetchurl {
      url = "https://josm.openstreetmap.de/download/macosx/josm-macos-${version}-java17.zip";
      hash = "sha256-f8VoPMF7cR6idzadkXC6/oUfzq4dnKb3UPa2JjsRNsw=";
    };
    pkg = fetchsvn {
      url = "https://josm.openstreetmap.de/svn/trunk/native/linux/tested";
      rev = version;
      sha256 = "sha256-/zdOaiyuvSwdVZcnw0ghDj2I+YKpFLc12fjZUMtRtVg=";
    };
  };
in
stdenv.mkDerivation rec {
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
        --add-flags "${extraJavaOpts} -jar $out/share/josm/josm.jar" \
        --prefix LD_LIBRARY_PATH ":" '${libXxf86vm}/lib'
    '';

  meta = with lib; {
    description = "An extensible editor for OpenStreetMap";
    homepage = "https://josm.openstreetmap.de/";
    changelog = "https://josm.openstreetmap.de/wiki/Changelog";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rycee sikmir ];
    platforms = platforms.all;
  };
}
