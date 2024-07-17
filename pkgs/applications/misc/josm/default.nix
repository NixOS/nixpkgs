{
  lib,
  stdenv,
  fetchurl,
  fetchsvn,
  makeWrapper,
  unzip,
  jre,
  libXxf86vm,
  extraJavaOpts ? "-Djosm.restart=true -Djava.net.useSystemProxies=true",
}:
let
  pname = "josm";
  version = "19067";
  srcs = {
    jar = fetchurl {
      url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
      hash = "sha256-+mHX80ltIFkVWIeex519b84BYzhp+h459/C2wlDR7jQ=";
    };
    macosx = fetchurl {
      url = "https://josm.openstreetmap.de/download/macosx/josm-macos-${version}-java21.zip";
      hash = "sha256-lMESSSXl6hBC2MpLYnYOThy463ft2bONNppBv3OEvAQ=";
    };
    pkg = fetchsvn {
      url = "https://josm.openstreetmap.de/svn/trunk/native/linux/tested";
      rev = version;
      sha256 = "sha256-L7P6FtqKLB4e+ezPzXePM33qj5esNoRlTFXi0/GhdsA=";
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
  buildInputs = lib.optionals (!stdenv.isDarwin) [ jre ];

  installPhase =
    if stdenv.isDarwin then
      ''
        mkdir -p $out/Applications
        ${unzip}/bin/unzip ${srcs.macosx} 'JOSM.app/*' -d $out/Applications
      ''
    else
      ''
        install -Dm644 ${srcs.jar} $out/share/josm/josm.jar
        cp -R ${srcs.pkg}/usr/share $out

        # Add libXxf86vm to path because it is needed by at least Kendzi3D plugin
        makeWrapper ${jre}/bin/java $out/bin/josm \
          --add-flags "${baseJavaOpts} ${extraJavaOpts} -jar $out/share/josm/josm.jar" \
          --prefix LD_LIBRARY_PATH ":" '${libXxf86vm}/lib'
      '';

  meta = with lib; {
    description = "An extensible editor for OpenStreetMap";
    homepage = "https://josm.openstreetmap.de/";
    changelog = "https://josm.openstreetmap.de/wiki/Changelog";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      rycee
      sikmir
    ];
    platforms = platforms.all;
    mainProgram = "josm";
  };
}
