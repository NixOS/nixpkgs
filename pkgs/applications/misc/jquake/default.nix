{ lib, stdenv, fetchurl, copyDesktopItems, makeDesktopItem, unzip, jre8
, logOutput ? false
}:

stdenv.mkDerivation rec {
  pname = "jquake";
  version = "1.8.4";

  src = fetchurl {
    url = "https://github.com/fleneindre/fleneindre.github.io/raw/master/downloads/JQuake_${version}_linux.zip";
    sha256 = "sha256-oIYkYmI8uG4zjnm1Jq1mzIcSwRlKbWJqvACygQyp9sA=";
  };

  nativeBuildInputs = [ unzip copyDesktopItems ];

  sourceRoot = ".";

  postPatch = ''
    # JQuake emits a lot of debug-like messages on stdout. Either drop the output
    # stream entirely or log them at 'user.debug' level.
    sed -i "/^java/ s/$/ ${if logOutput then "| logger -p user.debug" else "> \\/dev\\/null"}/" JQuake.sh

    # By default, an 'errors.log' file is created in the current directory.
    # cd into a temporary directory and let it be created there.
    substituteInPlace JQuake.sh \
      --replace "java -jar " "exec ${jre8.outPath}/bin/java -jar $out/lib/" \
      --replace "[JAR FOLDER]" "\$(mktemp -p /tmp -d jquake-errlog-XXX)"
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    chmod +x JQuake.sh

    mkdir -p $out/{bin,lib}
    mv JQuake.sh $out/bin/JQuake
    mv {JQuake.jar,JQuake_lib} $out/lib
    mv sounds $out/lib

    mkdir -p $out/share/licenses/jquake
    mv LICENSE* $out/share/licenses/jquake

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "JQuake";
      desktopName = "JQuake";
      exec = "JQuake";
      comment = "Real-time earthquake map of Japan";
    })
  ];

  meta = with lib; {
    description = "Real-time earthquake map of Japan";
    homepage = "https://jquake.net";
    downloadPage = "https://jquake.net/en/terms.html?os=linux&arch=any";
    changelog = "https://jquake.net/en/changelog.html";
    maintainers = with maintainers; [ nessdoor ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
