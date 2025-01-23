{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_7,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  jre,
  libGL,
  libX11,
  libXtst,
  libxkbcommon,
  libxcb,
  libXt,
  libXinerama,
}:

let
  gradle = gradle_7;

  libPath = lib.makeLibraryPath [
    # used by the Java2D OpenGL backend
    libGL
    # jnativehook dependencies
    libX11
    libXtst
    libxkbcommon
    libxcb
    libXt
    libXinerama
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "keyspersecond";
  version = "8.9";

  src = fetchFromGitHub {
    owner = "RoanH";
    repo = "KeysPerSecond";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DGpXbCInq+RS56Ae5Y6xzyWqwXAm26c0vOYrFqDvl+8=";
  };

  sourceRoot = "${finalAttrs.src.name}/KeysPerSecond";

  nativeBuildInputs = [
    gradle
    copyDesktopItems
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = "-PrefName=v${finalAttrs.version}";

  installPhase = ''
    runHook preInstall

    install -Dm644 resources/kps.png $out/share/icons/hicolor/64x64/apps/keyspersecond.png
    install -Dm644 build/libs/KeysPerSecond-v*.jar $out/share/keyspersecond/KeysPerSecond.jar

    # Note: we need to enable the Java2D OpenGL backend for proper transparency support
    makeWrapper ${jre}/bin/java $out/bin/KeysPerSecond \
        --prefix LD_LIBRARY_PATH : ${libPath} \
        --add-flags "-Dsun.java2d.opengl=True" \
        --add-flags "-jar $out/share/keyspersecond/KeysPerSecond.jar"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "keyspersecond";
      desktopName = "KeysPerSecond";
      exec = "KeysPerSecond";
      icon = "keyspersecond";
      comment = finalAttrs.meta.description;
      categories = [ "Utility" ];
    })
  ];

  meta = {
    changelog = "https://github.com/RoanH/KeysPerSecond/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Keys-per-second meter and counter for rhythm games";
    homepage = "https://github.com/RoanH/KeysPerSecond";
    license = lib.licenses.gpl3Only;
    mainProgram = "KeysPerSecond";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = jre.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
      binaryNativeCode # jnativehook shared library
    ];
  };
})
