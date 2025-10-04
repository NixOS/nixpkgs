{
  stdenv,
  lib,
  fetchFromGitHub,
  gradle,
  jdk24,
  wrapGAppsHook3,
  libXxf86vm,
  libXtst,
  libglvnd,
  glib,
  alsa-lib,
  ffmpeg,
  lsb-release,
  copyDesktopItems,
  makeDesktopItem,
  writeScript,
}:
stdenv.mkDerivation rec {
  pname = "ed-odyssey-materials-helper";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "jixxed";
    repo = "ed-odyssey-materials-helper";
    tag = version;
    hash = "sha256-tdpt0/TO7K1bK6OMCR9s5TbN1/v1ZywCzO/IvdOfsSA=";
  };

  nativeBuildInputs = [
    gradle
    wrapGAppsHook3
    copyDesktopItems
  ];

  patches = [
    # We'll set up the edomh: URL scheme in makeDesktopItem,
    # so this removes 1) the popup about it when you first start the program, 2) the option in the settings
    # and makes the program always know that it is set up
    ./remove-urlscheme-settings.patch
  ];
  postPatch = ''
    # oslib doesn't seem to do releases and hasn't had a change since 2021, so always use commit d6ee6549bb
    # it is not the latest commit because using a commit here whose hash starts with a number causes issues, but this works
    substituteInPlace build.gradle \
      --replace-fail '"com.github.wille:oslib:master-SNAPSHOT"' '"com.github.wille:oslib:d6ee6549bb"'
    substituteInPlace application/src/main/java/module-info.java \
      --replace-fail 'requires oslib.master.SNAPSHOT;' 'requires oslib.d6ee6549bb;'

    # remove "new version available" popup
    substituteInPlace application/src/main/java/nl/jixxed/eliteodysseymaterials/FXApplication.java \
      --replace-fail 'versionPopup();' ""

    for f in build.gradle */build.gradle; do
      substituteInPlace $f \
        --replace-fail 'vendor = JvmVendorSpec.AZUL' ""
    done
  '';

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk24}"
    "--stacktrace"
  ];

  gradleBuildTask = "application:jpackage";

  env = {
    EDDN_SOFTWARE_NAME = "EDO Materials Helper";
  };

  preBuild = ''
    # required to make EDDN_SOFTWARE_NAME work and for the program to know its own version
    gradle $gradleFlags application:generateSecrets
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share/ed-odyssey-materials-helper,bin}
    cp -r application/build/jpackage/Elite\ Dangerous\ Odyssey\ Materials\ Helper/* $out/share/ed-odyssey-materials-helper

    mkdir -p $out/share/icons/hicolor/512x512/apps/
    ln -s $out/share/ed-odyssey-materials-helper/lib/Elite\ Dangerous\ Odyssey\ Materials\ Helper.png $out/share/icons/hicolor/512x512/apps/ed-odyssey-materials-helper.png

    runHook postInstall
  '';

  dontWrapGApps = true;

  postFixup = ''
    makeWrapper $out/share/ed-odyssey-materials-helper/bin/Elite\ Dangerous\ Odyssey\ Materials\ Helper $out/bin/ed-odyssey-materials-helper \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libXxf86vm
          glib
          libXtst
          libglvnd
          alsa-lib
          ffmpeg
        ]
      } \
      --prefix PATH : ${lib.makeBinPath [ lsb-release ]} \
      "''${gappsWrapperArgs[@]}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ed-odyssey-materials-helper";
      type = "Application";
      desktopName = "Elite Dangerous Odyssey Materials Helper";
      comment = "Helper for managing materials in Elite Dangerous Odyssey";
      icon = "ed-odyssey-materials-helper";
      exec = "ed-odyssey-materials-helper %u";
      categories = [ "Game" ];
      mimeTypes = [ "x-scheme-handler/edomh" ];
    })
  ];

  gradleUpdateScript = ''
    runHook preBuild

    gradle application:nixDownloadDeps -Dos.family=linux -Dos.arch=amd64
    gradle application:nixDownloadDeps -Dos.family=linux -Dos.arch=aarch64
  '';

  passthru.updateScript = writeScript "update-ed-odyssey-materials-helper" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p nix-update

    nix-update ed-odyssey-materials-helper # update version and hash
    `nix-build --no-out-link -A ed-odyssey-materials-helper.mitmCache.updateScript` # update deps.json
  '';

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
    maintainers = with lib.maintainers; [
      elfenermarcell
      toasteruwu
    ];
    mainProgram = "ed-odyssey-materials-helper";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
