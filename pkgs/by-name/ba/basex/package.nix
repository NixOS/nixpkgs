{
  lib,
  stdenv,
  fetchurl,
  unzip,
  jre,
  coreutils,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "basex";
<<<<<<< HEAD
  version = "12.1";
=======
  version = "12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchurl {
    url = "http://files.basex.org/releases/${version}/BaseX${
      builtins.replaceStrings [ "." ] [ "" ] version
    }.zip";
<<<<<<< HEAD
    hash = "sha256-vxndej8+WhnC1G493MWdxXV4MUBXYTSPC8sccyd07ao=";
=======
    hash = "sha256-/9TeaAp2jckG77F8+J3aSpkoXWyTFXvXxnxXgpn58Zc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    unzip
    copyDesktopItems
  ];
  buildInputs = [ jre ];

  desktopItems = lib.optional (!stdenv.hostPlatform.isDarwin) (makeDesktopItem {
    name = "basex";
    exec = "basexgui %f";
    icon = "${./basex.svg}"; # icon copied from Ubuntu basex package
    comment = "Visually query and analyse your XML data";
    desktopName = "BaseX XML Database";
    genericName = "XML database tool";
    categories = [
      "Development"
      "Utility"
      "Database"
    ];
    mimeTypes = [ "text/xml" ];
  });

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Remove Windows batch files (unclutter $out/bin)
    rm ./bin/*.bat

    mkdir -p "$out/share/basex"

    cp -R bin etc lib webapp src BaseX.jar "$out"
    cp -R readme.txt webapp "$out/share/basex"

    # Use substitutions instead of wrapper scripts
    for file in "$out"/bin/*; do
        sed -i -e "s|/usr/bin/env bash|${stdenv.shell}|" \
               -e "s|java|${jre}/bin/java|" \
               -e "s|readlink|${coreutils}/bin/readlink|" \
               -e "s|dirname|${coreutils}/bin/dirname|" \
               -e "s|basename|${coreutils}/bin/basename|" \
               -e "s|echo|${coreutils}/bin/echo|" \
            "$file"
    done

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "XML database and XPath/XQuery processor";
    longDescription = ''
      BaseX is a very fast and light-weight, yet powerful XML database and
      XPath/XQuery processor, including support for the latest W3C Full Text
      and Update Recommendations. It supports large XML instances and offers a
      highly interactive front-end (basexgui). Apart from two local standalone
      modes, BaseX offers a client/server architecture.
    '';
    homepage = "https://basex.org/";
<<<<<<< HEAD
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.bjornfor ];
=======
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
