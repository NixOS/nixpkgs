{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
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
  version = "26.05.05";

  src = fetchFromGitHub {
    owner = "SchildiChat";
    repo = "schildi-revenge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B12OcryErrrFyKFweCFQWnbt/L8HvceAhBI51TlT3pg=";
    fetchSubmodules = true;
  };

  cargoRoot = "matrix-rust-sdk";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-8HI7UtuO2eg3/Zb2PhX0jvTDaIOpCCY0EHkrsdzSEkc=";
  };

  nativeBuildInputs = [
    jdk21
    gradle
    git
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  gradleBuildTask = "createReleaseDistributable";

  gradleUpdateScript = ''
    runHook preBuild

    gradle composeApp:dependencies composeApp:checkRuntime --write-verification-metadata sha256
    ##### Fallback
    ## If the update script starts missing dependencies after an update this should still work.
    ## Unfortunately it also unnecessarily builds the entire rust crate
    #gradle createReleaseDistributable --write-verification-metadata sha256
  '';

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  installPhase = ''
    runHook preInstall

    BUILD_DIR="composeApp/build/compose/binaries/main-release/app/SchildiChatRevenge"

    mkdir -p $out/share/{applications,icons/scalable}
    cp -r $BUILD_DIR/bin $out/bin
    cp -r $BUILD_DIR/lib $out/lib

    cp -r graphics/ic_launcher_foreground.svg $out/share/icons/scalable/ic_launcher.svg
    cp -r launcher/SchildiChatRevenge.desktop $out/share/applications

    runHook postInstall
  '';

  postFixup = ''
    patchelf $out/lib/app/libskiko-linux-x64.so \
    --add-rpath ${lib.makeLibraryPath [ libGL ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Matrix client for desktop written in Kotlin and using the Matrix Rust SDK";
    mainProgram = "SchildiChatRevenge";
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
