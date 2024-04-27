{ stdenv, lib, fetchurl, fetchzip, jdk11, unzip, makeWrapper, makeDesktopItem, copyDesktopItems }:

stdenv.mkDerivation rec {
  pname = "conduktor";
  version = "2.15.1";

  src = fetchzip {
    url = "https://github.com/conduktor/builds/releases/download/v${version}/Conduktor-linux-${version}.zip";
    sha256 = "sha256-9y/7jni5zIITUWd75AxsfG/b5vCYotmeMeC9aYM2WEs=";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  desktopItems = makeDesktopItem {
    type = "Application";
    name = pname;
    desktopName = "Conduktor";
    genericName = meta.description;
    exec = pname;
    icon = fetchurl {
      url = "https://github.com/conduktor/builds/raw/v${version}/.github/resources/Conduktor.png";
      sha256 = "0s7p74qclvac8xj2m22gfxx5m2c7cf0nqpk5sb049p2wvryhn2j4";
    };
    comment = "A beautiful and fully-featured desktop client for Apache Kafka";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/applications
    mv * $out
    wrapProgram "$out/bin/conduktor" --set JAVA_HOME "${jdk11.home}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Apache Kafka Desktop Client";
    longDescription = ''
      Conduktor is a GUI over the Kafka ecosystem, to make the development
      and management of Apache Kafka clusters as easy as possible.
    '';
    homepage = "https://www.conduktor.io/";
    changelog = "https://www.conduktor.io/changelog/#${version}";
    license = licenses.unfree;
    maintainers = with maintainers; [ trobert ];
    platforms = platforms.linux;
  };
}
