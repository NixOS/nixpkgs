{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ant,
  jdk17,
  makeWrapper,
  stripJavaArchivesHook,
  nix-update-script,
}:

let
  jdk = jdk17;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openrocket";
  version = "24.12";

  src = fetchFromGitHub {
    owner = "openrocket";
    repo = "openrocket";
    tag = "release-${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Vb1NkhEkMvotyGzswq3Lq0RbG1rTmtfzRD+MHbsYFWM=";
  };

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ant unittest
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    sed -i "s|Icon=.*|Icon=openrocket|g" snap/gui/openrocket.desktop
    install -Dm644 snap/gui/openrocket.desktop -t $out/share/applications
    install -Dm644 snap/gui/openrocket.png -t $out/share/icons/hicolor/256x256/apps
    install -Dm644 swing/build/jar/OpenRocket.jar -t $out/share/openrocket

    makeWrapper ${lib.getExe jdk} $out/bin/openrocket \
      --add-flags "-jar $out/share/openrocket/OpenRocket.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^release-(.*)$"
    ];
  };

  meta = {
    changelog = "https://github.com/openrocket/openrocket/releases/tag/${finalAttrs.src.rev}";
    description = "Model-rocketry aerodynamics and trajectory simulation software";
    homepage = "https://openrocket.info";
    license = lib.licenses.gpl3Plus;
    mainProgram = "openrocket";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = jdk.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
  };
})
