{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_8,
  jdk21,
  fontconfig,
  libxinerama,
  libxrandr,
  file,
  gtk3,
  glib,
  cups,
  lcms2,
  alsa-lib,
  libglvnd,
  udev,
  dconf,
  dpkg,
  rpm,
  gsettings-desktop-schemas,
  hicolor-icon-theme,
  adwaita-icon-theme,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  autoPatchelfHook,
  writeShellApplication,
  writeShellScriptBin,
  nix-update,
  git,
  nix,
  coreutils,
  kdePackages,
}:

let
  kreadconfig5Shim = writeShellScriptBin "kreadconfig5" ''
    exec ${lib.getExe' kdePackages.kconfig "kreadconfig6"} "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bifrost";
  version = "2.1.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zacharee";
    repo = "Bifrost";
    tag = finalAttrs.version;
    hash = "sha256-0LnErYWnsLhFIrZujaVXWLgGRtGXladxfsI0uJ/Fv2c=";
  };

  patches = [
    ./0001-fix-gradle-plugin-and-desktop-toolchain.patch
    ./0002-remove-foojay-resolver.patch
  ];

  postPatch = ''
    echo "kotlin.native.ignoreDisabledTargets=true" >> local.properties
  ''
  + lib.optionalString stdenv.isLinux ''
    # iOS Info.plist stamping needs macOS plutil; no-op on Linux.
    substituteInPlace common/build.gradle.kts \
      --replace-fail '"/usr/bin/plutil"' '"${lib.getExe' coreutils "true"}"'
  '';

  gradleBuildTask = ":desktop:createReleaseDistributable";
  gradleUpdateTask = finalAttrs.gradleBuildTask;

  gradleUpdateScript = ''
    runHook preBuild

    gradle :desktop:checkRuntime -PskipAndroid=true -Dos.family=linux -Dos.arch=amd64
    gradle :common:compileKotlinJvm -PskipAndroid=true
    gradle :desktop:nixDownloadDeps -PskipAndroid=true -Dos.family=linux -Dos.arch=amd64
    gradle :desktop:nixDownloadDeps -PskipAndroid=true -Dos.family=linux -Dos.arch=aarch64
    gradle :desktop:nixDownloadDeps -PskipAndroid=true -Dos.name='Mac OS X' -Dos.arch=amd64
    gradle :desktop:nixDownloadDeps -PskipAndroid=true -Dos.name='Mac OS X' -Dos.arch=aarch64
  '';

  env.JAVA_HOME = jdk21;
  env.ANDROID_USER_HOME = "$TMPDIR/android";
  env.GRADLE_USER_HOME = "$TMPDIR/gradle";

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk21}"
    "-PskipAndroid=true"
  ];

  nativeBuildInputs = [
    gradle_8
    jdk21
    copyDesktopItems
    makeWrapper
  ]
  ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    fontconfig
    libxinerama
    libxrandr
    file
    gtk3
    glib
    cups
    lcms2
    alsa-lib
    libglvnd
  ];

  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "bifrost";
      exec = "Bifrost";
      icon = "bifrost";
      desktopName = "Bifrost";
      comment = "Samsung firmware downloader";
      categories = [ "Utility" ];
    })
  ];

  installPhase =
    if stdenv.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/bin $out/Applications
        cp --recursive desktop/build/compose/binaries/main-release/app/Bifrost.app \
          $out/Applications/Bifrost.app

        makeWrapper $out/Applications/Bifrost.app/Contents/MacOS/Bifrost $out/bin/Bifrost

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/bin $out/opt/bifrost
        cp --recursive desktop/build/compose/binaries/main-release/app/Bifrost/* $out/opt/bifrost/
        rm -rf $out/opt/bifrost/lib/runtime
        ln -s ${jdk21}/lib/openjdk $out/opt/bifrost/lib/runtime
        install -D --mode=0644 $out/opt/bifrost/lib/Bifrost.png \
          $out/share/icons/hicolor/512x512/apps/bifrost.png

        makeWrapper $out/opt/bifrost/bin/Bifrost $out/bin/Bifrost \
          --prefix PATH : "${
            lib.makeBinPath (
              [
                glib
                dconf
                dpkg
                rpm
              ]
              ++ lib.optionals stdenv.isLinux [
                kreadconfig5Shim
                kdePackages.kconfig
              ]
            )
          }" \
          --set GSETTINGS_SCHEMA_DIR "${glib.getSchemaPath gsettings-desktop-schemas}" \
          --prefix XDG_DATA_DIRS : "${
            lib.makeSearchPath "share" [
              gsettings-desktop-schemas
              hicolor-icon-theme
              adwaita-icon-theme
            ]
          }" \
          --prefix LD_LIBRARY_PATH : "${
            lib.makeLibraryPath [
              stdenv.cc.cc.lib
              udev
              libglvnd
            ]
          }"

        runHook postInstall
      '';

  mitmCache = gradle_8.fetchDeps {
    inherit (finalAttrs) pname;
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-bifrost";
      runtimeInputs = [
        coreutils
        git
        nix
        nix-update
      ];
      text = ''
        set -euo pipefail

        nix-update bifrost
        updatePath="$(nix-build -A bifrost.mitmCache.updateScript --no-out-link)"
        "$updatePath"
      '';
    });
  };

  meta = {
    description = "Samsung firmware downloader";
    homepage = "https://github.com/zacharee/Bifrost";
    license = lib.licenses.mit;
    mainProgram = "Bifrost";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ mio ];
  };
})
