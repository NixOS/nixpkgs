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
  version = "26.08.08-1";

  src = fetchFromGitHub {
    owner = "SchildiChat";
    repo = "schildi-revenge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SbDdC910EdQy4HEwovuHjTzK4zEbzeI1w6pEQ1EQAGI=";
    fetchSubmodules = true;
  };

  cargoRoot = "matrix-rust-sdk";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-P0NcsKNmLHlfZ8tMjkfOChLrJ7l5tc9xy6FtZqyL1As=";
  };

  nativeBuildInputs = [
    jdk21
    gradle_9
    git
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];
  #broken entry unused entry in Cargo.toml, can probably be removed with next update
  postUnpack = ''
      substituteInPlace ./source/matrix-rust-sdk/Cargo.toml --replace-fail \
      "ruma = { git = \"https://github.com/matrix-org/ruma\", rev = \"2a1d714314f6f711d5bca755c73cf2ce3053c3d1\" }" \
    ""
  '';

  gradleBuildTask = "createReleaseDistributable";

  gradleUpdateScript = ''
    runHook preBuild

    gradle composeApp:dependencies composeApp:checkRuntime --write-verification-metadata sha256
    ##### Fallback
    ## If the update script starts missing dependencies after an update this should still work.
    ## Unfortunately it also unnecessarily builds the entire rust crate
    #gradle createReleaseDistributable --write-verification-metadata sha256
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
