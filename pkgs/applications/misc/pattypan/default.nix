{ lib
, stdenv
, fetchFromGitHub
, unzip
, jre
, jdk
, ant
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, glib
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pattypan";
  version = "22.03";

  src = fetchFromGitHub {
    owner = "yarl";
    repo = "pattypan";
    rev = "v${version}";
    sha256 = "0qmvlcqhqw5k500v2xdakk340ymgv5amhbfqxib5s4db1w32pi60";
  };

  nativeBuildInputs = [ copyDesktopItems jdk ant makeWrapper wrapGAppsHook ];
  buildInputs = [ glib jre ];

  buildPhase = ''
    runHook preBuild
    export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
    ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/java
    cp pattypan.jar $out/share/java/pattypan.jar
    makeWrapper ${jre}/bin/java $out/bin/pattypan \
      --add-flags "-cp $out/share/java/pattypan.jar pattypan.Launcher"
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Pattypan";
      genericName = "An uploader for Wikimedia Commons";
      categories = [ "Utility" ];
      exec = "pattypan";
      name = "pattypan";
    })
  ];

  meta = with lib; {
    homepage = "https://commons.wikimedia.org/wiki/Commons:Pattypan";
    description = "An uploader for Wikimedia Commons";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ fee1-dead ];
  };
}
