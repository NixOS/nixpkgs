{ lib
, stdenv
, fetchurl
, makeDesktopItem
, jre
, gtk3
, glib
, gnome
, wrapGAppsHook
, libXtst
, which
}:

stdenv.mkDerivation rec {
  pname = "smartgithg";
  version = "22.1.3";

  src = fetchurl {
    url = "https://www.syntevo.com/downloads/smartgit/smartgit-linux-${builtins.replaceStrings [ "." ] [ "_" ] version}.tar.gz";
    sha256 = "sha256-TnpjRFInqmlY02fGi7oxoS4P1DzahryFvNLitJ5NjM4=";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = [ jre gnome.adwaita-icon-theme gtk3 ];

  preFixup = with lib; ''
    gappsWrapperArgs+=( \
      --prefix PATH : ${makeBinPath [ jre which ]} \
      --prefix LD_LIBRARY_PATH : ${makeLibraryPath [
        gtk3
        glib
        libXtst
      ]} \
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

  desktopItem = with lib; makeDesktopItem rec {
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
