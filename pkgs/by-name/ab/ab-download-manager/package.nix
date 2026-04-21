{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  autoPatchelfHook,
  makeWrapper,
  libxinerama,
  libxrandr,
  libxcursor,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,

  # Runtime deps for the bundled JBR and Compose/Skia renderer
  fontconfig,
  freetype,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  libxxf86vm,
  libGL,
  glib,
  gtk3,
  alsa-lib,
  pkgs,
  cups,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ab-download-manager";
  version = "1.8.7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "amir1376";
    repo = "ab-download-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YDARV3pbT8jvWuYthgKN+XxgJdDuZNbfqvfddKnp1Ls=";
  };

  postPatch = ''
    sed -i '/include("android:app")/d' settings.gradle.kts
    sed -i '/include("common-android")/d' compositeBuilds/plugins/settings.gradle.kts
    sed -i '/ir.amirab.plugin:common-android/d' buildSrc/build.gradle.kts
    sed -i '/^installerPlugin {$/,/^\/\/ ======= end of GitHub action stuff$/d' desktop/app/build.gradle.kts

    # Add mac target formats so JetBrains compose registers the task on Darwin
    sed -i 's/targetFormats(Msi, Deb)/targetFormats(Msi, Deb, Dmg, Pkg)/' desktop/app/build.gradle.kts

    # Create dummy git repo for git-version-plugin
    git init
    git config user.name "nixbld"
    git config user.email "nixbld@localhost"
    git add .
    git commit -m "init"
    git tag v${finalAttrs.version}
  '';

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  env.JAVA_HOME = pkgs.openjdk;

  gradleFlags = [
    "-Dorg.gradle.java.home=${pkgs.openjdk}"
  ];

  preConfigure = ''
    export HOME="$TMPDIR/home"
    export ANDROID_USER_HOME="$HOME/.android"
    export XDG_CONFIG_HOME="$TMPDIR/.config"
    export JAVA_TOOL_OPTIONS="-Duser.home=$HOME"
    mkdir -p "$HOME" "$ANDROID_USER_HOME" "$XDG_CONFIG_HOME"
  '';

  gradleBuildTask = "createDistributable";
  gradleUpdateTask = finalAttrs.gradleBuildTask;

  nativeBuildInputs = [
    gradle_9
    makeWrapper
    pkgs.git
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    fontconfig
    freetype
    glib
    stdenv.cc.cc.lib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxext
    libxi
    libxrender
    libxtst
    libxxf86vm
    libGL
    libxinerama
    libxrandr
    libxcursor
    gtk3
    alsa-lib
    cups
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "com.abdownloadmanager";
      desktopName = "AB Download Manager";
      comment = "Manage and organize your download files better than before";
      genericName = "Downloader";
      categories = [
        "Utility"
        "Network"
      ];
      exec = "ABDownloadManager %u";
      icon = "ab-download-manager";
      terminal = false;
      startupWMClass = "com-abdownloadmanager-desktop-AppKt";
      mimeTypes = [ "x-scheme-handler/magnet" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          local appDir=desktop/app/build/compose/binaries/main/app/ABDownloadManager.app

          mkdir -p $out/Applications
          cp -r "$appDir" $out/Applications/

          mkdir -p $out/bin
          makeWrapper $out/Applications/ABDownloadManager.app/Contents/MacOS/ABDownloadManager $out/bin/ABDownloadManager
        ''
      else
        ''
          local appDir=desktop/app/build/compose/binaries/main/app/ABDownloadManager

          mkdir -p $out/lib/ab-download-manager
          cp -r "$appDir"/. $out/lib/ab-download-manager/

          mkdir -p $out/bin
          makeWrapper $out/lib/ab-download-manager/bin/ABDownloadManager $out/bin/ABDownloadManager

          install -Dm644 $out/lib/ab-download-manager/lib/ABDownloadManager.png \
            $out/share/icons/hicolor/512x512/apps/ab-download-manager.png
        ''
    }

    runHook postInstall
  '';

  appendRunpaths = lib.optionals stdenv.hostPlatform.isLinux [
    "${libGL}/lib"
    "${libx11}/lib"
    "${glib}/lib"
    "${gtk3}/lib"
    "${stdenv.cc.cc.lib}/lib"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Download manager that speeds up your downloads with multi-connection support";
    longDescription = ''
      AB Download Manager is a free and open-source desktop download manager
      with support for queues, schedulers, browser extensions, multiple themes,
      and multi-segment downloading for faster speeds.
    '';
    homepage = "https://abdownloadmanager.com";
    changelog = "https://github.com/amir1376/ab-download-manager/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "ABDownloadManager";
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
