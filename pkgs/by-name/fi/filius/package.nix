{
  stdenvNoCC,
  lib,
  fetchzip,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  jre,
}:
let
  # we cache potentially unstable upstream inputs (icon and .zip file) via https://web.archive.org - this is a standard procedure in Nixpkgs
  icon128 = fetchurl {
    url = "https://web.archive.org/web/20240623123147/https://dl.flathub.org/repo/appstream/x86_64/icons/128x128/de.lernsoftware_filius.Filius.png";
    hash = "sha256-xES6RWf2KiNsukD6GwTuPyiDI6SseADGLb1AkBSTgd8=";
  };
  icon32 = fetchurl {
    url = "https://gitlab.com/filius1/filius/-/raw/09fa7d5bdc60d5b4a2ab0e24311d54516a400913/src/deb/filius32.png";
    hash = "sha256-sVsViRALhiVJFSxfVb9K6Q4M7Y2UEvZh6oOB9BQumh8=";
  };
  mimetype_xml = fetchurl {
    url = "https://gitlab.com/filius1/filius/-/raw/09fa7d5bdc60d5b4a2ab0e24311d54516a400913/src/deb/application-filius-project.xml";
    hash = "sha256-tChNuWlMuQtGeavQm12FDXCacfPTzFY8p/646WZnHDI=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "filius";

  # UPDATE instructions
  #
  # - Open https://www.lernsoftware-filius.de/Herunterladen and copy download link to clipboard.
  #   (e.g. https://www.lernsoftware-filius.de/downloads/Setup/filius-2.5.1.zip)
  # - identify the new version string.
  version = "2.6.1";

  # - Open http://web.archive.org and paste download link from clipboard into "Save Page Now" field and hit the "Save Page" button.
  # - Unselect "Save Error Pages" and hit "Save Page" again.
  # - Wait for the archive link to be generated and copy it to the url field - adjust hash accordingly.
  src = fetchzip {
    url = "https://web.archive.org/web/20240829130608/https://www.lernsoftware-filius.de/downloads/Setup/filius-2.6.1.zip";
    hash = "sha256-vrzImMorA1BPA7LRjyZ2pXqLT9ry8qx7Jps5uyTZDp8=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "Filius";
      desktopName = "Filius";
      genericName = "Computer network simulator";
      comment = "A Computer network simulator for secondary schools";
      icon = "filius";
      exec = "filius";
      terminal = false;
      mimeTypes = [ "application/filius-project" ];
      categories = [ "Education" ];
      startupNotify = false;
      extraConfig = {
        "GenericName[en]" = "Computer network simulator";
        "GenericName[de]" = "Computer-Netzwerksimulator";
        "Comment[en]" = "A computer network simulator for secondary schools";
        "Comment[de]" = "Ein Computer-Netzwerksimulator für Bildungszwecke";
      };
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    export CUSTOM_LIBS=$out/share/java
    export JAR=$CUSTOM_LIBS/filius.jar

    # "install -D" creates missing folders
    install -D filius.jar $JAR
    cp -r . $CUSTOM_LIBS/

    makeWrapper ${jre}/bin/java $out/bin/filius \
      --add-flags "-Duser.dir=$CUSTOM_LIBS/" \
      --add-flags "-jar $JAR" \
      --add-flags '-n -wd $HOME' \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=lcd'

    runHook postInstall
  '';

  postInstall = ''
    mimetypeDir=$out/share/
    install -D ${mimetype_xml} $out/share/mime/packages/application-filius-project.xml
    install -D ${icon32} $out/share/icons/hicolor/32x32/mimetypes/filius32.png

    install -Dm444 ${icon128} $out/share/icons/hicolor/128x128/apps/filius.png
    install -Dm444 ${icon32} $out/share/icons/hicolor/32x32/apps/filius.png
  '';

  meta = {
    homepage = "https://www.lernsoftware-filius.de";
    downloadPage = "https://www.lernsoftware-filius.de/Herunterladen";
    description = "A Computer Network Simulator for Secondary Schools";
    longDescription = ''
      With the software tool Filius, you can design computer networks yourself,
      simulate the exchange of messages in them and thus explore their structure
      and functionality experimentally. The target group are learners at secondary
      level in general education schools. Filius enables learning activities that
      are designed to support discovery-based learning in particular.";
    '';
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
    ];
    maintainers = with lib.maintainers; [
      annaaurora
      rcmlz
    ];
    platforms = lib.platforms.all;
    mainProgram = "filius";
  };
})
