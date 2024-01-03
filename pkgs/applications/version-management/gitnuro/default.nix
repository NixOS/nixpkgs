{ lib
, stdenv
, fetchurl
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, jre
, libGL
}:

stdenv.mkDerivation rec {
  pname = "gitnuro";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/JetpackDuba/Gitnuro/releases/download/v${version}/Gitnuro-linux-x86_64-${version}.jar";
    hash = "sha256-7yne9dD/7VT+H4tIBJvpOf8ksECCpoNAa8TSmFmjYMw=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/JetpackDuba/Gitnuro/4cfc45069c176f807d9bfb1a7cba410257078d3c/icons/logo.svg";
    hash = "sha256-QGJcWTSJesIpDArOWiS3Kn1iznzeMFzvqS+CuNXh3as=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/gitnuro \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}" \
      --add-flags "-jar $src"

    install -Dm444 $icon $out/share/icons/hicolor/scalable/apps/com.jetpackduba.Gitnuro.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Gitnuro";
      exec = "gitnuro";
      icon = "com.jetpackduba.Gitnuro";
      desktopName = "Gitnuro";
      categories = [ "Development" ];
      comment = meta.description;
    })
  ];

  meta = with lib; {
    description = "A FOSS Git multiplatform client based on Compose and JGit";
    homepage = "https://gitnuro.com/";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ zendo ];
    mainProgram = "gitnuro";
  };
}
