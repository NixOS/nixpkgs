{
  lib,
  stdenv,
  fetchFromGitHub,
  ant,
  jdk,
  jre,
  makeWrapper,
  copyDesktopItems,
  stripJavaArchivesHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dayon";
  version = "17.0.0";

  src = fetchFromGitHub {
    owner = "RetGal";
    repo = "dayon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YGp27LYtiEHUkkHvAxm6M9ORPqOdpPcyDoRMqKGS8To=";
  };

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    copyDesktopItems
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/dayon.jar $out/share/dayon/dayon.jar
    # jre is in PATH because dayon needs keytool to generate certificates
    makeWrapper ${lib.getExe jre} $out/bin/dayon \
      --prefix PATH : "${lib.makeBinPath [ jre ]}" \
      --add-flags "-jar $out/share/dayon/dayon.jar"
    makeWrapper ${lib.getExe jre} $out/bin/dayon_assisted \
      --prefix PATH : "${lib.makeBinPath [ jre ]}" \
      --add-flags "-cp $out/share/dayon/dayon.jar mpo.dayon.assisted.AssistedRunner"
    makeWrapper ${lib.getExe jre} $out/bin/dayon_assistant \
      --prefix PATH : "${lib.makeBinPath [ jre ]}" \
      --add-flags "-cp $out/share/dayon/dayon.jar mpo.dayon.assistant.AssistantRunner"
    install -Dm644 resources/dayon.png $out/share/icons/hicolor/128x128/apps/dayon.png

    runHook postInstall
  '';

  desktopItems = [
    "debian/dayon_assisted.desktop"
    "debian/dayon_assistant.desktop"
  ];

  meta = {
    description = "Easy to use, cross-platform remote desktop assistance solution";
    homepage = "https://retgal.github.io/Dayon/index.html";
    license = lib.licenses.gpl3Plus; # https://github.com/RetGal/Dayon/issues/59
    mainProgram = "dayon";
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
