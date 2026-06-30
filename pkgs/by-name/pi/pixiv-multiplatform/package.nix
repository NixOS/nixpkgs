{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScriptBin,
  makeDesktopItem,
  copyDesktopItems,
  rustPlatform,
  makeWrapper,
  jre,
  jdk17,
  gradle,
  androidenv,
  pkg-config,
  wayland,
  libGL,
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

  # https://github.com/magic-cucumber/Pixiv-MultiPlatform/blob/v1.8.4/composeApp/build.gradle.kts#L85
  jdk = jdk17;

  gif =
    pixiv-multiplatform:
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "pixiv-multiplatform-gif";
      inherit (pixiv-multiplatform) src version;
      sourceRoot = "${finalAttrs.src.name}/lib/gif/src/rust";
      cargoHash = "sha256-dq2xoOsCsFKq0YJQgD3nGOBbtU/XfP3iSKv/rxSJw3U=";
      meta = { inherit (pixiv-multiplatform.meta) license maintainers; };
    });

  file-picker =
    pixiv-multiplatform:
    rustPlatform.buildRustPackage (finalAttrs: {
      pname = "pixiv-multiplatform-file-picker";
      inherit (pixiv-multiplatform) src version;
      sourceRoot = "${finalAttrs.src.name}/lib/file-picker/src/rust";
      cargoHash = "sha256-VuAqbu+aTYG2p74tqCEQhiU0yfMT/XmefkdE29CU7hw=";
      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ wayland ];
      meta = { inherit (pixiv-multiplatform.meta) license maintainers; };
    });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "pixiv-multiplatform";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "magic-cucumber";
    repo = "Pixiv-MultiPlatform";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O0cWA3vitVjPmCkh5QBlhl8OYhJIAuVHW6ij4KYqDDs=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.gitrev
      rm -rf $out/.git
    '';
  };

  __darwinAllowLocalNetworking = true;

  buildInputs = [ jre ];
  nativeBuildInputs = [
    jdk
    gradle
    fake-git # https://github.com/magic-cucumber/Pixiv-MultiPlatform/blob/v1.8.4/composeApp/build.gradle.kts#L434
    copyDesktopItems
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  gradleFlags = [ "-Dfile.encoding=utf-8" ];
  gradleBuildTask = "packageReleaseDistributionForCurrentOS";

  env = {
    # https://github.com/magic-cucumber/Pixiv-MultiPlatform/blob/v1.8.4/.github/workflows/publish-release.yml#L80
    APP_VERSION_NAME = finalAttrs.src.tag;
    # Actually useless but it has to be there to please AGP
    ANDROID_HOME = "${finalAttrs.passthru.androidPkgs.androidsdk}/libexec/android-sdk";
  };

  preConfigure = ''
    mkdir -p lib/{gif,file-picker}/src/rust/target/release
    cp ${finalAttrs.passthru.gif}/lib/* lib/gif/src/rust/target/release
    cp ${finalAttrs.passthru.file-picker}/lib/* lib/file-picker/src/rust/target/release

    # AGP needs these dirs to be existent and writable
    export HOME=$(mktemp -d)
    export ANDROID_SDK_HOME=$HOME
    export ANDROID_USER_HOME=$ANDROID_SDK_HOME/.android
    export KONAN_DATA_DIR=$HOME/.konan
    mkdir -p $ANDROID_USER_HOME $KONAN_DATA_DIR
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt,bin,share/icons/hicolor/256x256/apps}
    cp -ar composeApp/build/compose/binaries/main-release/app/Pixiv-MultiPlatform $out/opt
    ln -s $out/opt/Pixiv-MultiPlatform/lib/Pixiv-MultiPlatform.png $out/share/icons/hicolor/256x256/apps/pixiv-multiplatform.png
    makeWrapper $out/opt/Pixiv-MultiPlatform/bin/Pixiv-MultiPlatform $out/bin/Pixiv-MultiPlatform \
      --suffix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}

    runHook postInstall
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
    androidPkgs = androidenv.composeAndroidPackages (import ./android.nix);
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
    ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "Pixiv-MultiPlatform";
  };
})
