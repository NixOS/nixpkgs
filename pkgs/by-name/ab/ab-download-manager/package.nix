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
  openjdk,
  git,
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
    # Remove Android-specific modules and dependencies as we only build the desktop version.
    substituteInPlace settings.gradle.kts \
      --replace-fail 'include("android:app")' ""

    substituteInPlace compositeBuilds/plugins/settings.gradle.kts \
      --replace-fail 'include("common-android")' ""

    # Fix broken dependency reference that occurs if only partial replacement is used.
    substituteInPlace buildSrc/build.gradle.kts \
      --replace-fail 'implementation("ir.amirab.plugin:common-android:1")' ""

    # Remove ben-manes.versions plugin: it tries to call api.github.com
    substituteInPlace build.gradle.kts \
      --replace-fail \
        '    com.github.`ben-manes`.versions' \
        ""

    # Add mac target formats so JetBrains compose registers the task on Darwin.
    substituteInPlace desktop/app/build.gradle.kts \
      --replace-fail \
        'targetFormats(Msi, Deb)' \
        'targetFormats(Msi, Deb, Dmg, Pkg)'

    # Remove installerPlugin block to avoid unnecessary build steps.
    sed -i '/^installerPlugin {$/,/^\/\/ ======= end of GitHub action stuff$/d' desktop/app/build.gradle.kts

    # Remove the dependencyUpdates task block that references the removed plugin.
    sed -i '/^tasks\.dependencyUpdates {/,/^}/d' build.gradle.kts

    # Create dummy git repo for git-version-plugin which requires a tagged commit to determine version.
    git init
    git -c user.name=nixbld -c user.email=nixbld@localhost commit --allow-empty -m init
    git tag v${finalAttrs.version}
  '';

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  env = {
    JAVA_HOME = openjdk;
    HOME = ".home";
    ANDROID_USER_HOME = ".android"; # The Android plugin requires a writable home even for desktop builds.
    XDG_CONFIG_HOME = ".config";
  };

  # The MITM proxy and Gradle's FileLockContentionHandler both bind to loopback
  # ports. Restrict to loopback only rather than any local interface.
  sandboxProfile = ''
    (allow network-outbound (local ip4 "*:*") (local ip6 "*:*"))
    (allow network-bind     (local ip4 "*:*") (local ip6 "*:*"))
    (allow network-inbound  (local ip4 "*:*") (local ip6 "*:*"))
  '';

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    glib
    gtk3
    stdenv.cc.cc.lib
  ];

  gradleFlags = [
    "-Dorg.gradle.java.home=${openjdk}"
  ];

  gradleBuildTask = "createDistributable";
  gradleUpdateTask = finalAttrs.gradleBuildTask;

  nativeBuildInputs = [
    gradle_9
    makeWrapper
    git
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # Darwin uses coretext so no issues
    fontconfig
    freetype
    libxext
    libxi
    libxrender
    libxtst
    libxxf86vm
    libxinerama
    libxrandr
    libxcursor
    alsa-lib
    cups
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
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

    local applicationName="ABDownloadManager"
    local packageIdentifier="ab-download-manager"
    local buildDirectory="desktop/app/build/compose/binaries/main/app"

    mkdir -p "$out/bin"

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications"
      cp -r "$buildDirectory/$applicationName.app" "$out/Applications/"

      makeWrapper "$out/Applications/$applicationName.app/Contents/MacOS/$applicationName" \
        "$out/bin/$applicationName"
    ''}

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      local targetLibraryDirectory="$out/lib/$packageIdentifier"

      mkdir -p "$targetLibraryDirectory"
      cp -r "$buildDirectory/$applicationName/." "$targetLibraryDirectory/"

      install -D -m 644 "$targetLibraryDirectory/lib/$applicationName.png" \
        "$out/share/icons/hicolor/512x512/apps/$packageIdentifier.png"

      makeWrapper "$targetLibraryDirectory/bin/$applicationName" \
        "$out/bin/$applicationName"
    ''}

    runHook postInstall
  '';

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
