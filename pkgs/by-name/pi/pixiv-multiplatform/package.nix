{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScriptBin,
  makeDesktopItem,
  copyDesktopItems,
  rustPlatform,
  makeWrapper,
  wrapGAppsHook3,
  jdk25,
  gradle_9,
  pkg-config,
  wayland,
  libGL,
  libx11,
  fontconfig,
  glib,
  gtk3,
  webkitgtk_4_1,
  nix-update-script,
}:

let
  fake-git = writeShellScriptBin "git" ''
    path=$(pwd)
    while [[ "$path" != "" && "$path" != "/" ]]; do
      if [[ -f "$path/.gitrev" ]]; then
        cat "$path/.gitrev"
        exit
      fi
      path=$(dirname "$path")
    done
    echo "fatal: not a git repository" >&2
    exit 128
  '';

  # https://github.com/magic-cucumber/Pixiv-MultiPlatform/blob/v1.8.7/composeApp/build.gradle.kts#L87
  jdk = jdk25;
  gradle = gradle_9.override { java = jdk; };

  gif =
    pixiv-multiplatform:
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "pixiv-multiplatform-gif";
      inherit (pixiv-multiplatform) src version;
      sourceRoot = "${finalAttrs.src.name}/lib/gif/src/rust";
      buildFeatures = [ "jvm" ];
      cargoHash = "sha256-ccwheSiCNCvk+UfC0uEHxzDjWvd6/zhCT62DLwtYMKU=";
      meta = { inherit (pixiv-multiplatform.meta) license maintainers; };
    });

  file-picker =
    pixiv-multiplatform:
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "pixiv-multiplatform-file-picker";
      inherit (pixiv-multiplatform) src version;
      sourceRoot = "${finalAttrs.src.name}/lib/file-picker/src/rust";
      buildFeatures = [ "jvm" ];
      cargoHash = "sha256-YUsaoaa31bgwSFcU8WARboBlRxMAsrkR7j51FQ7IV1Y=";
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ wayland ];
      meta = { inherit (pixiv-multiplatform.meta) license maintainers; };
    });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "pixiv-multiplatform";
  version = "1.8.7";

  src = fetchFromGitHub {
    owner = "magic-cucumber";
    repo = "Pixiv-MultiPlatform";
    tag = "v${finalAttrs.version}";
    postCheckout = "git -C $out rev-parse --short HEAD > $out/.gitrev";
    hash = "sha256-NpPAaALVg5cMSpG7LVrrla1bahU2g6WhMqyVT4OL3y4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Avoid configuring the Android NDK when building the desktop distribution.
  patches = [ ./disable-android-native-build.patch ];

  buildInputs = [ gtk3 ];
  nativeBuildInputs = [
    jdk
    gradle
    fake-git # https://github.com/magic-cucumber/Pixiv-MultiPlatform/blob/v1.8.7/composeApp/build.gradle.kts#L452
    copyDesktopItems
    makeWrapper
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  gradleFlags = [
    "-Dfile.encoding=utf-8"
    # the excluded native libraries are built separately with buildRustPackage
    "-x"
    ":lib:gif:jvmCargoBuildRelease"
    "-x"
    ":lib:file-picker:jvmCargoBuildRelease"
  ];
  gradleBuildTask = "createReleaseDistributable";
  gradleUpdateTask = finalAttrs.gradleBuildTask;

  env = {
    # https://github.com/magic-cucumber/Pixiv-MultiPlatform/blob/v1.8.7/.github/workflows/publish-release.yml#L80
    APP_VERSION_NAME = finalAttrs.src.tag;
  };

  preConfigure = ''
    gradleFlagsArray+=("-Duser.home=$TMPDIR")

    mkdir -p lib/{gif,file-picker}/src/rust/target/release
    cp ${finalAttrs.passthru.gif}/lib/* lib/gif/src/rust/target/release
    cp ${finalAttrs.passthru.file-picker}/lib/* lib/file-picker/src/rust/target/release

    # AGP requires an SDK directory even when only building the desktop app
    export ANDROID_HOME="$TMPDIR/android-sdk"
    export ANDROID_USER_HOME="$TMPDIR/android-user-home"
    export KONAN_DATA_DIR="$TMPDIR/konan"
    mkdir -p "$ANDROID_HOME" "$ANDROID_USER_HOME" "$KONAN_DATA_DIR"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt,bin,share/icons/hicolor/256x256/apps}
    cp -ar composeApp/build/compose/binaries/main-release/app/Pixiv-MultiPlatform $out/opt
    ln -s $out/opt/Pixiv-MultiPlatform/lib/Pixiv-MultiPlatform.png $out/share/icons/hicolor/256x256/apps/pixiv-multiplatform.png

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper $out/opt/Pixiv-MultiPlatform/bin/Pixiv-MultiPlatform $out/bin/Pixiv-MultiPlatform \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "$out/opt/Pixiv-MultiPlatform/lib/runtime/lib:${
        lib.makeLibraryPath [
          libGL
          libx11
          fontconfig
          glib
          gtk3
          webkitgtk_4_1
          (lib.getLib stdenv.cc.cc)
        ]
      }"
  '';

  desktopItems = [
    (makeDesktopItem {
      comment = finalAttrs.meta.description;
      name = "pixiv-multiplatform";
      desktopName = "Pixiv-MultiPlatform";
      exec = "Pixiv-MultiPlatform %U";
      icon = "pixiv-multiplatform";
      categories = [ "Network" ];
    })
  ];

  passthru = {
    gif = gif finalAttrs;
    file-picker = file-picker finalAttrs;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross-platform third-party Pixiv client based on Kotlin technology stack";
    homepage = "https://pmf.kagg886.top";
    changelog = "https://github.com/magic-cucumber/Pixiv-MultiPlatform/releases";
    downloadPage = "https://github.com/magic-cucumber/Pixiv-MultiPlatform/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
      binaryNativeCode # WebView, Skiko and SQLite libraries bundled in JARs
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "Pixiv-MultiPlatform";
    platforms = [ "x86_64-linux" ]; # limited by bundled WebView library
  };
})
