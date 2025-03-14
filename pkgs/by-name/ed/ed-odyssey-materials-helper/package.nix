{
  stdenv,
  lib,
  fetchFromGitHub,
  gradle,
  jdk23,
  makeWrapper,
  libXxf86vm,
  libXtst,
  libglvnd,
  glib,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "ed-odyssey-materials-helper";
  version = "2.144";

  src = fetchFromGitHub {
    owner = "jixxed";
    repo = "ed-odyssey-materials-helper";
    tag = version;
    hash = "sha256-ilvZLjS5Aoa6pYq6gs6UKFbUvCEYLjpSBQ5Xxe8HfjU=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
    copyDesktopItems
  ];

  postPatch = ''
    # oslib doesn't seem to do releases and hasn't had a change since 2021, so always use commit d6ee6549bb
    # it is not the latest commit because using a commit here whose hash starts with a number causes issues, but this works
    substituteInPlace build.gradle \
      --replace-fail '"com.github.wille:oslib:master-SNAPSHOT"' '"com.github.wille:oslib:d6ee6549bb"'
    substituteInPlace application/src/main/java/module-info.java \
      --replace-fail 'requires oslib.master.SNAPSHOT;' 'requires oslib.d6ee6549bb;'
  '';

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk23}" ];

  gradleBuildTask = "application:jpackage";
  gradleUpdateTask = "application:nixDownloadDeps";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share/ed-odyssey-materials-helper,bin}
    cp -r application/build/jpackage/Elite\ Dangerous\ Odyssey\ Materials\ Helper/* $out/share/ed-odyssey-materials-helper

    makeWrapper $out/share/ed-odyssey-materials-helper/bin/Elite\ Dangerous\ Odyssey\ Materials\ Helper $out/bin/ed-odyssey-materials-helper \
      --run 'mkdir -p ~/.config/odyssey-materials-helper/ && cd ~/.config/odyssey-materials-helper/' \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libXxf86vm
          glib
          libXtst
          libglvnd
        ]
      }

    mkdir -p $out/share/icons/hicolor/512x512/apps/
    ln -s $out/share/ed-odyssey-materials-helper/lib/Elite\ Dangerous\ Odyssey\ Materials\ Helper.png $out/share/icons/hicolor/512x512/apps/ed-odyssey-materials-helper.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ed-odyssey-materials-helper";
      desktopName = "Elite Dangerous Odyssey Materials Helper";
      comment = "Helper for managing materials in Elite Dangerous Odyssey";
      exec = "ed-odyssey-materials-helper";
      type = "Application";
      icon = "ed-odyssey-materials-helper";
      categories = [
        "Game"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Helper for managing materials in Elite Dangerous Odyssey";
    homepage = "https://github.com/jixxed/ed-odyssey-materials-helper";
    downloadPage = "https://github.com/jixxed/ed-odyssey-materials-helper/releases/tag/${version}";
    changelog = "https://github.com/jixxed/ed-odyssey-materials-helper/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    maintainers = with lib.maintainers; [ elfenermarcell ];
    mainProgram = "ed-odyssey-materials-helper";
    platforms = lib.platforms.linux;
  };
}
