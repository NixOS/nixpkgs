{ stdenv, fetchurl, makeDesktopItem, jre, makeWrapper }:

let
  desktopItem = makeDesktopItem {
    categories = "Network;Development;WebDevelopment;Java;";
    desktopName = "Charles";
    exec = "charles %F";
    genericName  = "Web Debugging Proxy";
    icon = "charles-proxy";
    mimeType = "application/x-charles-savedsession;application/x-charles-savedsession+xml;application/x-charles-savedsession+json;application/har+json;application/vnd.tcpdump.pcap;application/x-charles-trace";
    name = "Charles";
    startupNotify = "true";
  };

in stdenv.mkDerivation rec {
  name = "charles-${version}";
  version = "4.2.7";

  src = fetchurl {
    url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.tar.gz";
    sha256 = "1nycw3wpbfwj4ijjaq5k0f4xipj8j605fs0yjzgl66gmv7r583rd";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    makeWrapper ${jre}/bin/java $out/bin/charles \
      --add-flags "-Xmx1024M -Dcharles.config='~/.charles.config' -jar $out/share/java/charles.jar"

    for fn in lib/*.jar; do
      install -D -m644 $fn $out/share/java/$(basename $fn)
    done

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    mkdir -p $out/share/icons
    cp -r icon $out/share/icons/hicolor
  '';

  meta = with stdenv.lib; {
    description = "Web Debugging Proxy";
    homepage = https://www.charlesproxy.com/;
    maintainers = [ maintainers.kalbasit ];
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
