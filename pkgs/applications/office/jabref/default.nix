{ stdenv, fetchurl, makeWrapper, makeDesktopItem, jdk, jre, wrapGAppsHook, gtk3, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  version = "4.3.1";
  name = "jabref-${version}";

  src = fetchurl {
    url = "https://github.com/JabRef/jabref/releases/download/v${version}/JabRef-${version}.jar";
    sha256 = "15f3risav4vlr3jvmrn93qfw54filfxl99h6j3cmj2j3kh3ywljv";
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

  buildInputs = [ makeWrapper jdk wrapGAppsHook gtk3 gsettings-desktop-schemas ];

  unpackPhase = "#";

  installPhase = ''
    mkdir -p $out/bin $out/share/java $out/share/icons

    cp -r ${desktopItem}/share/applications $out/share/

    jar xf $src images/external/JabRef-icon-128.png
    cp images/external/JabRef-icon-128.png $out/share/icons/jabref.png

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
