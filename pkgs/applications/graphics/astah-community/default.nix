{ stdenv, fetchurl, makeWrapper, makeDesktopItem, unzip, jre }:

let

  name = "astah-community";
  version = "7.2.0";
  postfix = "1ff236";
  desktopIcon = fetchurl {
    name = "${name}.png";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/astah_community.png?h=astah-community&id=94710b5a6aadcaf489022b0f0e61f8832ae6fa87";
    sha256 = "0knlknwfqqnhg63sxxpia5ykn397id31gzr956wnn6yjj58k3ckm";
  };
  mimeXml = fetchurl {
    name = "${name}.xml";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/astah_community.xml?h=astah-community&id=94710b5a6aadcaf489022b0f0e61f8832ae6fa87";
    sha256 = "096n2r14ddm97r32i4sbp7v4qdmwn9sxy7lwphcx1nydppb0m97b";
  };
  desktopItem = makeDesktopItem {
    name = name;
    exec = "astah %U";
    icon = "${desktopIcon}";
    comment = "Lightweight, easy-to-use, and free UML2.x modeler";
    desktopName = "Astah* Community";
    genericName = "Astah* Community";
    mimeType = "application/x-astah";
    categories = "Application;Development;";
    extraEntries = "NoDisplay=false";
  };

in

stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "http://cdn.change-vision.com/files/${name}-${stdenv.lib.replaceStrings ["."] ["_"] version}-${postfix}.zip";
    sha256 = "1lkl30jdjiarvh2ap9rjabvrq9qhrlmfrasv3vvkag22y9w4l499";
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r . $out/share/astah
    cp -r ${desktopItem}/share/applications $out/share/applications

    install -D ${desktopIcon} $out/share/pixmaps/${name}.png
    install -D ${mimeXml} $out/share/mime/packages/${name}.xml

    makeWrapper ${jre}/bin/java $out/bin/astah \
      --add-flags "-jar $out/share/astah/astah-community.jar"

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Lightweight, easy-to-use, and free UML2.x modeler";
    homepage = http://astah.net/editions/community;
    license = licenses.unfree;
  };
}
