{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  gradle_9,
  openjdk21,
  nix-update-script,
  libGL,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  fontconfig,
  libxkbcommon,
  perl,
}:

let
  gradle = gradle_9.override { java = openjdk21; };

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
  version = "6.4.1";

  src = fetchFromGitHub {
    owner = "shub39";
    repo = "Rush";
    rev = finalAttrs.version;
    hash = "sha256-nsWbgNU04hazvdtaeYBCYoOOmoQ9NQKJBLFzrL9XnJM=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
    copyDesktopItems
    perl
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
    # Workaround for update script failing with __structuredAttrs = true
    # Can be removed once https://github.com/NixOS/nixpkgs/pull/532975 is merged
    pkg = finalAttrs.finalPackage.overrideAttrs (old: {
      __structuredAttrs = false;
      strictDeps = false;
    });
  };

  gradleFlags = [
    "-Dfile.encoding=utf-8"
    "-x"
    "spotlessCheck"
    "-x"
    "spotlessKotlin"
    "-x"
    "spotlessKotlinGradle"
    "--no-configuration-cache"
  ];

  gradleBuildTask = ":desktopApp:createDistributable";

  # Compile JVM subprojects during preGradleUpdate stage to prevent dependency verification issues
  preGradleUpdate = ''
    gradle :shared:core:jvmJar :shared:logic:jvmJar :shared:ui:jvmJar :desktopApp:checkRuntime
  '';

  postPatch = ''
    # Remove Android subprojects from settings
    sed -i '/:android/d' settings.gradle.kts

    # Strip Android KMP library plugin and configuration
    for file in shared/*/build.gradle.kts; do
      substituteInPlace "$file" \
        --replace-fail "alias(libs.plugins.android.kotlin.multiplatform.library)" ""
    done

    # Remove Android blocks and dependencies
    perl -0777 -pe 's/^\s{4}android\s*\{.*?\n\s{4}\}//gms' -i shared/*/build.gradle.kts
    perl -0777 -pe 's/^\s{8}androidMain\.dependencies\s*\{.*?\n\s{8}\}//gms' -i shared/ui/build.gradle.kts
    perl -pe 's/^\s*androidMain\.dependencies\s*\{.*?\}//g' -i shared/logic/build.gradle.kts
    perl -0777 -pe 's/androidRuntimeClasspath\(.*?\)//gs' -i shared/ui/build.gradle.kts
    perl -0777 -pe 's/^androidComponents\s*\{.*?\n\}//gms' -i shared/ui/build.gradle.kts

    # Delete androidLibs reference & kspAndroid dependency
    sed -i '/kspAndroid/d' shared/logic/build.gradle.kts

    # Disable Gradle configuration cache as it conflicts with task serialization
    echo "org.gradle.configuration-cache=false" >> gradle.properties
    echo "org.gradle.unsafe.configuration-cache=false" >> gradle.properties
  '';

  installPhase = ''
    runHook preInstall

    APP_DIR=$(find desktopApp/build/compose/binaries/ -type d -name "Rush" | head -n 1)
    if [ -z "$APP_DIR" ]; then
      echo "Could not find compiled application folder in binaries/"
      exit 1
    fi

    mkdir -p $out/share/rush-lyrics
    cp -r "$APP_DIR"/* $out/share/rush-lyrics/

    # Wrap runtime binary to prefix graphics libraries
    makeWrapper $out/share/rush-lyrics/bin/Rush $out/bin/rush-lyrics \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

    # Install icon
    install -m 444 -D fastlane/metadata/android/en-US/images/icon.png $out/share/icons/hicolor/512x512/apps/rush-lyrics.png

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
    license = lib.licenses.gpl3Plus;
    platforms = [
      "x86_64-linux"
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
