{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  nix-update-script,
  libGL,
  jdk21,
  git,
  cargo,
  rustc,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schildi-revenge";
  version = "26.10.01";

  src = fetchFromGitHub {
    owner = "SchildiChat";
    repo = "schildi-revenge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5AOxfJ41/9MIvhbmUXdU2fGBT48h8dBAm77P4xlWei8=";
    fetchSubmodules = true;
  };

  cargoRoot = "matrix-rust-sdk";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-6v5VqUwiIfkGhByoZN9hVm4zANAgTWHpPBdVHGFmGNc=";
  };

  nativeBuildInputs = [
    jdk21
    gradle_9
    git
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  # Workaround for a Vergen related build failure
  env = {
    VERGEN_GIT_SHA = "0000000000000000000000000000000000000000";
  };

  gradleBuildTask = "createReleaseDistributable";

  gradleUpdateScript = ''
    runHook preBuild

    gradle createReleaseDistributable composeApp:kspCommonMainKotlinMetadata --write-verification-metadata sha256
  '';

  mitmCache = gradle_9.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  installPhase = ''
    runHook preInstall

    BUILD_DIR="composeApp/build/compose/binaries/main-release/app/schildichat-revenge"

    mkdir -p $out/share/{applications,icons/scalable}
    cp -r $BUILD_DIR/bin $out/bin
    cp -r $BUILD_DIR/lib $out/lib

    cp -r graphics/ic_launcher_foreground.svg $out/share/icons/scalable/ic_launcher.svg
    cp -r launcher/schildichat-revenge.desktop $out/share/applications

    runHook postInstall
  '';

  postFixup = ''
    patchelf $out/lib/app/libskiko-linux-x64.so \
    --add-rpath ${lib.makeLibraryPath [ libGL ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Matrix client for desktop written in Kotlin and using the Matrix Rust SDK";
    mainProgram = "schildichat-revenge";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    homepage = "https://schildi.chat/revenge";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    maintainers = with lib.maintainers; [
      _71rd
      xeni
    ];
  };
})
