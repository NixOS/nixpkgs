{ lib, stdenv, fetchurl, fetchFromGitHub, makeWrapper, unzip, jre, libXxf86vm
, extraJavaOpts ? "-Djosm.restart=true -Djava.net.useSystemProxies=true"
}:
let
  pname = "josm";
  version = "19253";
  srcs = {
    jar = fetchurl {
      url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
      hash = "sha256-GnN+XtGzhLZ2PKAGHv+GMMh0FpilwET7EfKI4CAwYgg=";
    };
    macosx = fetchurl {
      url = "https://josm.openstreetmap.de/download/macosx/josm-macos-${version}-java21.zip";
      hash = "sha256-bcCl+w+pvsR+8QXKjM9bVyTAgzp+wre71tZMp5+VJTA=";
    };
    pkg = fetchFromGitHub {
      owner = "JOSM";
      repo = "josm";
      rev = "refs/tags/${version}-tested";
      hash = "sha256-I1mMtNzFkBoU0qcx2rVd9nmDK91ccVyaKwPft72M3r0=";
    };
  };

  # Needed as of version 19017.
  baseJavaOpts = toString [
    "--add-exports=java.base/sun.security.action=ALL-UNNAMED"
    "--add-exports=java.desktop/com.sun.imageio.plugins.jpeg=ALL-UNNAMED"
    "--add-exports=java.desktop/com.sun.imageio.spi=ALL-UNNAMED"
  ];
in
stdenv.mkDerivation rec {
  inherit pname version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ jre ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then ''
      mkdir -p $out/Applications
      ${unzip}/bin/unzip ${srcs.macosx} 'JOSM.app/*' -d $out/Applications
    '' else ''
      install -Dm644 ${srcs.jar} $out/share/josm/josm.jar
      cp -R ${srcs.pkg}/native/linux/tested/usr/share $out

      # Add libXxf86vm to path because it is needed by at least Kendzi3D plugin
      makeWrapper ${jre}/bin/java $out/bin/josm \
        --add-flags "${baseJavaOpts} ${extraJavaOpts} -jar $out/share/josm/josm.jar" \
        --prefix LD_LIBRARY_PATH ":" '${libXxf86vm}/lib'
    '';

  meta = {
    description = "Extensible editor for OpenStreetMap";
    homepage = "https://josm.openstreetmap.de/";
    changelog = "https://josm.openstreetmap.de/wiki/Changelog";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ rycee sikmir ];
    platforms = lib.platforms.all;
    mainProgram = "josm";
  };
}
