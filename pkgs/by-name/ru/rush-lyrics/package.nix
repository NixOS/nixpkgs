{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  gradle_9,
  nix-update-script,
  libGL,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  fontconfig,
  libxkbcommon,
  playerctl,
}:

let
  runtimeLibs = [
    libGL
    libx11
    libxext
    libxi
    libxrender
    libxtst
    fontconfig
    libxkbcommon
  ];
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "rush-lyrics";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "shub39";
    repo = "Rush";
    tag = finalAttrs.version;
    hash = "sha256-SHeg8ZHV+xhB5AUPRaGy0288SKFeL7eJCmOvU8EBVZQ=";
  };

  patches = [
    ./remove-android.patch
  ];

  postPatch = ''
    substituteInPlace desktopApp/build.gradle.kts \
      --replace-fail 'implementation(compose.desktop.currentOs)' \
                     $'implementation(compose.desktop.linux_x64)\n            implementation(compose.desktop.linux_arm64)'
  '';

  nativeBuildInputs = [
    gradle_9
    makeWrapper
    copyDesktopItems
  ];

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dfile.encoding=utf-8"
    "-x"
    "spotlessCheck"
    "--no-configuration-cache"
  ];

  gradleBuildTask = ":desktopApp:createDistributable";

  # Compile JVM subprojects during preGradleUpdate stage to prevent dependency verification issues
  preGradleUpdate = ''
    gradle :shared:core:jvmJar :shared:logic:jvmJar :shared:ui:jvmJar :desktopApp:checkRuntime
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rush-lyrics
    cp -r desktopApp/build/compose/binaries/main/app/Rush/* $out/share/rush-lyrics/

    # Wrap runtime binary to prefix graphics libraries and playerctl CLI
    makeWrapper $out/share/rush-lyrics/bin/Rush $out/bin/rush-lyrics \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
      --prefix PATH : "${lib.makeBinPath [ playerctl ]}"

    # Install icon
    install -Dm644 fastlane/metadata/android/en-US/images/icon.png $out/share/icons/hicolor/512x512/apps/rush-lyrics.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rush-lyrics";
      desktopName = "Rush";
      genericName = "Lyrics App";
      comment = "App to search, save and share lyrics like Spotify";
      exec = "rush-lyrics";
      icon = "rush-lyrics";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
        "Utility"
      ];
    })
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "App to search, save and share lyrics like Spotify";
    homepage = "https://github.com/shub39/Rush";
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "rush-lyrics";
    maintainers = with lib.maintainers; [
      irgendeinwer
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # Dependencies pulled via mitm-cache
    ];
  };
})
