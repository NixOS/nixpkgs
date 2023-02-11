{ copyDesktopItems
, fetchurl
, glib
, gnome
, gtk3
, jre
, lib
, makeDesktopItem
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "deepgit";
  version = "4.3";

  src = fetchurl {
    url = "https://www.syntevo.com/downloads/deepgit/deepgit-linux-${lib.replaceStrings [ "." ] [ "_" ] version}.tar.gz";
    hash = "sha256-bA/EySZjuSDYaZplwHcpeP1VakcnG5K1hYTk7cSVbz0=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook
  ];

  buildInputs = [
    gnome.adwaita-icon-theme
    gtk3
    jre
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ glib gtk3 ]}
      --set DEEPGIT_JAVA_HOME ${jre}
    )
    patchShebangs bin/deepgit.sh
  '';

  desktopItems = [(makeDesktopItem rec {
    name = pname;
    desktopName = "DeepGit";
    keywords = [ "git" ];
    comment = "Git-Client";
    categories = [
      "Development"
      "RevisionControl"
    ];
    terminal = false;
    startupNotify = true;
    startupWMClass = desktopName;
    exec = pname;
    mimeTypes = [
      "x-scheme-handler/${pname}"
      "x-scheme-handler/sourcetree"
    ];
    icon = pname;
  })];

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/{bin,share/icons/hicolor/scalable/apps/}
    cp -a lib license.html $out
    mv bin/deepgit.sh $out/bin/deepgit

    for icon_size in 32 48 64 128 256; do
      path=$icon_size'x'$icon_size
      icon=bin/deepgit-$icon_size.png
      mkdir -p $out/share/icons/hicolor/$path/apps
      cp $icon $out/share/icons/hicolor/$path/apps/deepgit.png
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "A tool to investigate the history of source code";
    homepage = "https://www.syntevo.com/deepgit";
    changelog = "https://www.syntevo.com/deepgit/changelog.txt";
    license = licenses.unfree;
    maintainers = with maintainers; [ urandom ];
    platforms = platforms.linux;
  };
}
