{ lib
, stdenv
, fetchFromGitHub
, ant
, jdk
, jre
, makeWrapper
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "dayon";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "RetGal";
    repo = "dayon";
    rev = "v${version}";
    hash = "sha256-2Fo+LQvsrDvqEudZxzQBtJHGxrRYUyNyhrPV1xS49pQ=";
  };

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    copyDesktopItems
  ];

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  desktopItems = [
    "resources/deb/dayon_assisted.desktop"
    "resources/deb/dayon_assistant.desktop"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 build/dayon.jar $out/share/dayon/dayon.jar
    mkdir -p $out/bin
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

  meta = with lib; {
    homepage = "https://retgal.github.io/Dayon/index.html";
    description = "An easy to use, cross-platform remote desktop assistance solution";
    license = licenses.gpl3Plus; # https://github.com/RetGal/Dayon/issues/59
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}
