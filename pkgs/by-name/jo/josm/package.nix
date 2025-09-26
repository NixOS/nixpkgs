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
  version = "19439";
  srcs = {
    jar = fetchurl {
      url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
      hash = "sha256-EuboKKNpApYlh9b78oB5AbtOM38oMe3NEa4fovA78Uk=";
    };
    macosx = fetchurl {
      url = "https://josm.openstreetmap.de/download/macosx/josm-macos-${version}-java21.zip";
      hash = "sha256-b38Xd0qx0ceNtJ5UIWDJkGOvaHSB/46onPbd6LJ6siY=";
    };
    pkg = fetchsvn {
      url = "https://josm.openstreetmap.de/svn/trunk/native/linux/tested";
      rev = version;
      hash = "sha256-9YTSX4chUxijtJ7a1pLE2kYo9hdOB/8vnnfFqMeXKbE=";
    };
  };

  # Needed as of version 19017.
  baseJavaOpts = toString [
    "--add-exports=java.base/sun.security.action=ALL-UNNAMED"
    "--add-exports=java.desktop/com.sun.imageio.plugins.jpeg=ALL-UNNAMED"
    "--add-exports=java.desktop/com.sun.imageio.spi=ALL-UNNAMED"
  ];
in
stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ jre ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
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
          --prefix LD_LIBRARY_PATH ":" '${libXxf86vm}/lib' \
          --prefix _JAVA_AWT_WM_NONREPARENTING : 1 \
          --prefix _JAVA_OPTIONS " " "-Dawt.useSystemAAFontSettings=gasp"
      '';

  passthru = {
    inherit srcs;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Extensible editor for OpenStreetMap";
    homepage = "https://josm.openstreetmap.de/";
    changelog = "https://josm.openstreetmap.de/wiki/Changelog";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      rycee
      sikmir
      starsep
    ];
    platforms = lib.platforms.all;
    mainProgram = "josm";
  };
}
