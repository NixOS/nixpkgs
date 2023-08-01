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
  version = "11.0.7";

  src = fetchFromGitHub {
    owner = "RetGal";
    repo = "dayon";
    rev = "v${version}";
    hash = "sha256-3TbJVM5po4aUAOsY7JJs/b5tUzH3WGnca/H83IeMQ2s=";
  };

  # https://github.com/RetGal/Dayon/pull/66
  postPatch = ''
    substituteInPlace resources/deb/dayon_assisted.desktop resources/deb/dayon_assistant.desktop \
      --replace "Exec=/usr/bin/" "Exec="
  '';

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
    makeWrapper ${jre}/bin/java $out/bin/dayon \
      --add-flags "-jar $out/share/dayon/dayon.jar"
    makeWrapper ${jre}/bin/java $out/bin/dayon_assisted \
      --add-flags "-cp $out/share/dayon/dayon.jar mpo.dayon.assisted.AssistedRunner"
    makeWrapper ${jre}/bin/java $out/bin/dayon_assistant \
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
