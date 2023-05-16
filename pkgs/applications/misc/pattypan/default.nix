{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
=======
, unzip
, jre
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  buildInputs = [ glib jdk ];
=======
  buildInputs = [ glib jre ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    makeWrapper ${jdk}/bin/java $out/bin/pattypan \
=======
    makeWrapper ${jre}/bin/java $out/bin/pattypan \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
