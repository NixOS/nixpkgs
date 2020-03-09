{ stdenv, fetchurl, makeWrapper, makeDesktopItem, jdk, jre, wrapGAppsHook, gtk3, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  version = "3.8.1";
  pname = "jabref";

  src = fetchurl {
    url = "https://github.com/JabRef/jabref/releases/download/v${version}/JabRef-${version}.jar";
    sha256 = "11asfym74zdq46i217z5n6vc79gylcx8xn7nvwacfqmym0bz79cg";
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

  dontUnpack = true;

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
    homepage = https://www.jabref.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.gebner ];
  };
}
