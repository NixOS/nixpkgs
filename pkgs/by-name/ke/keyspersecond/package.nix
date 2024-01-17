{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_7,
  perl,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  stripJavaArchivesHook,
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

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    name = "${finalAttrs.pname}-${finalAttrs.version}-deps";
    inherit (finalAttrs) src sourceRoot;

    nativeBuildInputs = [
      gradle
      perl
    ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon --console=plain shadowJar
    '';

    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-a1uU0LNwrEZ48Wkwj7tsibLAXVRyTtRQBRyZID8RtpQ=";
  };

  nativeBuildInputs = [
    gradle
    copyDesktopItems
    makeWrapper
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)
    substituteInPlace settings.gradle build.gradle \
        --replace-fail "repositories{" "repositories{ maven { url '${finalAttrs.deps}' }"

    gradle --offline --no-daemon --console=plain shadowJar -PrefName=v${finalAttrs.version}

    runHook postBuild
  '';

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
    description = "A keys-per-second meter and counter for rhythm games";
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
