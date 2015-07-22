{ stdenv, fetchurl, makeWrapper, makeDesktopItem, ant, jdk, jre }:

stdenv.mkDerivation rec {
  version = "2.10";
  name = "jabref-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/jabref/${version}/JabRef-${version}-src.tar.bz2";
    sha256 = "09b57afcfeb1730b58a887dc28f0f4c803e9c00fade1f57245ab70e2a98ce6ad";
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

  buildInputs = [ ant jdk makeWrapper ];

  buildPhase = ''ant'';

  installPhase = ''
    mkdir -p $out/bin $out/share/java $out/share/icons
    cp -r ${desktopItem}/share/applications $out/share/
    cp build/lib/JabRef-${version}.jar $out/share/java/
    cp src/images/JabRef-icon-mac.svg $out/share/icons/jabref.svg
    makeWrapper ${jre}/bin/java $out/bin/jabref \
      --add-flags "-jar $out/share/java/JabRef-${version}.jar"
  '';

  meta = with stdenv.lib; {
    description = "Open source bibliography reference manager";
    homepage = http://jabref.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.gebner ];
  };
}
