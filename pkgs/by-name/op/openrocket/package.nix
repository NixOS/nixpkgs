{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdk17,
  makeWrapper,
  gradle,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openrocket";
  version = "24.12";

  src = fetchFromGitHub {
    owner = "openrocket";
    repo = "openrocket";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-Vb1NkhEkMvotyGzswq3Lq0RbG1rTmtfzRD+MHbsYFWM=";
    fetchSubmodules = true;
  };

  # The mitmCache update script expects core dependency to be built before it pulls the swing dependency
  # first so we place a dunny jar file, jogamp repositories may fallback to HTTP, we substitute in a arg that allows the fallback
  postPatch = ''
    # This will satisfy the ExtraJavaModuleInfoTransform plugin during gradle.fetchDeps
    # by generating dummy JAR files before Gradle resolves the classpath.
    mkdir -p dummy_dir

    mkdir -p core/build/libs
    jar cf core/build/libs/core-${finalAttrs.version}.jar -C dummy_dir .

    mkdir -p swing/build/libs
    jar cf swing/build/libs/swing-${finalAttrs.version}.jar -C dummy_dir .

    # patch the jogamp repository to allow HTTP fallback redirects
    substituteInPlace build.gradle \
      --replace 'url "https://jogamp.org/deployment/maven/"' \
      'url "https://www.jogamp.org/deployment/maven/"; allowInsecureProtocol = true'
  '';

  nativeBuildInputs = [
    jdk17 # Only java 17 is supported as of 23.09
    makeWrapper
    gradle
  ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  doCheck = true;

  installPhase = ''
    runHook preInstall

    sed -i "s|Icon=.*|Icon=openrocket|g" snap/gui/openrocket.desktop
    install -Dm644 snap/gui/openrocket.desktop -t $out/share/applications
    install -Dm644 snap/gui/openrocket.png -t $out/share/icons/hicolor/256x256/apps
    install -Dm644 build/libs/OpenRocket-${finalAttrs.version}.jar -t $out/share/openrocket

    makeWrapper ${lib.getExe jdk17} $out/bin/openrocket \
        --add-flags "-jar $out/share/openrocket/OpenRocket-${finalAttrs.version}.jar"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/openrocket/openrocket/releases/tag/${finalAttrs.src.rev}";
    description = "Model-rocketry aerodynamics and trajectory simulation software";
    homepage = "https://openrocket.info";
    license = lib.licenses.gpl3Plus;
    mainProgram = "openrocket";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = jdk17.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
