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
stdenv.mkDerivation (finalAttrs: {
  pname = "smartgit";
  version = "24.1.5";

  src = fetchurl {
    url = "https://www.syntevo.com/downloads/smartgit/smartgit-linux-${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.tar.gz";
    hash = "sha256-YqueTbwA9KcXEJG5TeWkPzzNyAnnJQ1+VQYsqZKS2/I=";
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
      --prefix SMARTGIT_JAVA_HOME : ${jre} \
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

  desktopItem = makeDesktopItem {
    name = "smartgit";
    exec = "smartgit";
    comment = finalAttrs.meta.description;
    icon = "smartgit";
    desktopName = "SmartGit";
    categories = [
      "Development"
      "RevisionControl"
    ];
    mimeTypes = [
      "x-scheme-handler/git"
      "x-scheme-handler/smartgit"
      "x-scheme-handler/sourcetree"
    ];
    startupNotify = true;
    startupWMClass = "smartgit";
    keywords = [ "git" ];
  };

  meta = {
    description = "Git GUI client";
    longDescription = ''
      SmartGit is a multi-platform Git GUI client, free to use for active Open Source developers and users from academic institutions.
      Command line Git is required.
    '';
    homepage = "https://www.syntevo.com/smartgit/";
    changelog = "https://www.syntevo.com/smartgit/changelog-${lib.versions.majorMinor finalAttrs.version}.txt";
    license = lib.licenses.unfree;
    mainProgram = "smartgit";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jraygauthier
      tmssngr
    ];
  };
})
