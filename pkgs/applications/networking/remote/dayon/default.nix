{ lib
, stdenv
, fetchFromGitHub
, ant
, jdk
, jre
, makeWrapper
, copyDesktopItems
, stripJavaArchivesHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dayon";
  version = "14.0.1";

  src = fetchFromGitHub {
    owner = "RetGal";
    repo = "dayon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7XrgPrYKhaUvmXxiZLsduzrbyZRHjPSo+fg4BvlatHQ=";
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
    makeWrapper ${jre}/bin/java $out/bin/dayon \
      --prefix PATH : "${lib.makeBinPath [ jre ]}" \
      --add-flags "-jar $out/share/dayon/dayon.jar"
    makeWrapper ${jre}/bin/java $out/bin/dayon_assisted \
      --prefix PATH : "${lib.makeBinPath [ jre ]}" \
      --add-flags "-cp $out/share/dayon/dayon.jar mpo.dayon.assisted.AssistedRunner"
    makeWrapper ${jre}/bin/java $out/bin/dayon_assistant \
      --prefix PATH : "${lib.makeBinPath [ jre ]}" \
      --add-flags "-cp $out/share/dayon/dayon.jar mpo.dayon.assistant.AssistantRunner"
    install -Dm644 resources/dayon.png $out/share/icons/hicolor/128x128/apps/dayon.png

    runHook postInstall
  '';

  desktopItems = [
    "resources/deb/dayon_assisted.desktop"
    "resources/deb/dayon_assistant.desktop"
  ];

  postFixup = ''
    substituteInPlace $out/share/applications/*.desktop \
        --replace "/usr/bin/dayon/dayon.png" "dayon"
  '';

  meta = with lib; {
    description = "An easy to use, cross-platform remote desktop assistance solution";
    homepage = "https://retgal.github.io/Dayon/index.html";
    license = licenses.gpl3Plus; # https://github.com/RetGal/Dayon/issues/59
    mainProgram = "dayon";
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})
