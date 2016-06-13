{ stdenv, fetchurl, makeWrapper, makeDesktopItem, ant, jdk, jre }:

stdenv.mkDerivation rec {
  version = "3.3";
  name = "jabref-${version}";

  src = fetchurl {
    url = "https://github.com/JabRef/jabref/releases/download/v${version}/JabRef-${version}.jar";
    sha256 = "19ms68d74xg8jg9n52gh2j7a89dl5pnib3vjsnih1j45hlmfg0ac";
  };

  desktopItem = makeDesktopItem {
    comment =  meta.description;
    name = "jabref";
    desktopName = "JabRef";
    genericName = "Bibliography manager";
    categories = "Application;Office;";
    icon = "jabref";
    exec = "jabref";
  };

  buildInputs = [ makeWrapper jdk ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/java $out/share/icons

    cp -r ${desktopItem}/share/applications $out/share/

    jar xf $src images/icons/JabRef-icon-mac.svg
    cp images/icons/JabRef-icon-mac.svg $out/share/icons/jabref.svg

    ln -s $src $out/share/java/jabref-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/jabref \
      --add-flags "-jar $out/share/java/jabref-${version}.jar"
  '';

  meta = with stdenv.lib; {
    description = "Open source bibliography reference manager";
    homepage = http://jabref.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.gebner ];
  };
}
