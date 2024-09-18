{ lib
, stdenvNoCC
, fetchFromGitHub
, ant
, jdk17
, makeWrapper
, stripJavaArchivesHook
}:

let
  jdk = jdk17; # Only java 17 is supported as of 23.09
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openrocket";
  version = "23.09";

  src = fetchFromGitHub {
    owner = "openrocket";
    repo = "openrocket";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-Dg/v72N9cDG9Ko5JIcZxGxh+ClRDgf5Jq5DvQyCiYOs=";
    fetchSubmodules = true;
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

    makeWrapper ${jdk}/bin/java $out/bin/openrocket \
        --add-flags "-jar $out/share/openrocket/OpenRocket.jar"

    runHook postInstall
  '';

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
