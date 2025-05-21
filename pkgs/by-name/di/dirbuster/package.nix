{ lib
, stdenv
, fetchurl
, makeBinaryWrapper
, copyDesktopItems
, makeDesktopItem
, unzip
, jdk8
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dirbuster";
  version = "1.0-RC1";

  src = fetchurl {
    url = "mirror://sourceforge/dirbuster/DirBuster%20(jar%20%2B%20lists)/${finalAttrs.version}/DirBuster-${finalAttrs.version}.tar.bz2";
    hash = "sha256-UoEt1NkaLsKux3lr+AB+TZCCshQs2hIo63igT39V68E=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "dirbuster";
      desktopName = "OWASP DirBuster";
      exec = "dirbuster";
      icon = "dirbuster";
      comment = "Web Application Brute Forcing";
      categories = [ "Network" ];
    })
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
    unzip
  ];

  installPhase = ''
    runHook preInstall

    export JAR=$out/share/java/dirbuster.jar
    install -Dm444 DirBuster-${finalAttrs.version}.jar $JAR
    makeWrapper ${jdk8}/bin/java $out/bin/dirbuster \
      --add-flags "-Duser.dir=$out/share/dirbuster/" \
      --add-flags "-Xmx256M" \
      --add-flags "-jar $JAR"

    cp -r lib/ $out/share/java/lib/

    # Copy wordlists
    mkdir -p $out/share/dirbuster
    for f in *.txt; do
      cp $f $out/share/dirbuster/
    done

    # Extract embedded desktop icon
    mkdir -p $out/share/pixmaps
    unzip $JAR
    strings com/sittinglittleduck/DirBuster/ImageCreator.class | grep iVBORw0KG | base64 -d > $out/share/pixmaps/dirbuster.png

    runHook postInstall
  '';

  meta = {
    description = "Brute force directories and files names on web/application servers";
    homepage = "https://wiki.owasp.org/index.php/Category:OWASP_DirBuster_Project";
    license = lib.licenses.lgpl21Only;
    mainProgram = "dirbuster";
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
