{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  openjdk21,
  gtk3,
  glib,
  adwaita-icon-theme,
  wrapGAppsHook3,
  libXtst,
  which,
}:
let
  jre = openjdk21;
in
stdenv.mkDerivation rec {
  pname = "smartgithg";
  version = "23.1.3";

  src = fetchurl {
    url = "https://www.syntevo.com/downloads/smartgit/smartgit-linux-${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }.tar.gz";
    hash = "sha256-UvdHr1L5MYwl7eT1BVS/M8Ydtw8VjDG+QuqMW0Q5La4=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = [
    jre
    adwaita-icon-theme
    gtk3
  ];

  preFixup = ''
    gappsWrapperArgs+=( \
      --prefix PATH : ${
        lib.makeBinPath [
          jre
          which
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          gtk3
          glib
          libXtst
        ]
      } \
      --prefix JRE_HOME : ${jre} \
      --prefix JAVA_HOME : ${jre} \
      --prefix SMARTGITHG_JAVA_HOME : ${jre} \
    )
    # add missing shebang for start script
    sed -i $out/bin/smartgit \
      -e '1i#!/bin/bash'
  '';

  installPhase = ''
    runHook preInstall

    sed -i '/ --login/d' bin/smartgit.sh
    mkdir -pv $out/{bin,share/applications,share/icons/hicolor/scalable/apps/}
    cp -av ./{dictionaries,lib} $out/
    cp -av bin/smartgit.sh $out/bin/smartgit
    ln -sfv $out/bin/smartgit $out/bin/smartgithg

    cp -av $desktopItem/share/applications/* $out/share/applications/
    for icon_size in 32 48 64 128 256; do
        path=$icon_size'x'$icon_size
        icon=bin/smartgit-$icon_size.png
        mkdir -p $out/share/icons/hicolor/$path/apps
        cp $icon $out/share/icons/hicolor/$path/apps/smartgit.png
    done

    cp -av bin/smartgit.svg $out/share/icons/hicolor/scalable/apps/

    runHook postInstall
  '';

  desktopItem = makeDesktopItem rec {
    name = "smartgit";
    exec = "smartgit";
    comment = meta.description;
    icon = "smartgit";
    desktopName = "SmartGit";
    categories = [
      "Application"
      "Development"
      "RevisionControl"
    ];
    mimeTypes = [
      "x-scheme-handler/git"
      "x-scheme-handler/smartgit"
      "x-scheme-handler/sourcetree"
    ];
    startupNotify = true;
    startupWMClass = name;
    keywords = [ "git" ];
  };

  meta = with lib; {
    description = "GUI for Git, Mercurial, Subversion";
    homepage = "https://www.syntevo.com/smartgit/";
    changelog = "https://www.syntevo.com/smartgit/changelog.txt";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ jraygauthier ];
  };
}
