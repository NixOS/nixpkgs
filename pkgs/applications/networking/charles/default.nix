{ stdenv, fetchurl, makeDesktopItem, jre, hicolor-icon-theme }:

let
  desktopItem = makeDesktopItem {
    categories = "Network;Development;WebDevelopment;Java;";
    desktopName = "Charles";
    exec = "charles %F";
    genericName  = "Web Debugging Proxy";
    icon = "charles";
    mimeType = "application/x-charles-savedsession;application/x-charles-savedsession+xml;application/x-charles-savedsession+json;application/har+json;application/vnd.tcpdump.pcap;application/x-charles-trace";
    name = "Charles";
    startupNotify = "true";
  };

in stdenv.mkDerivation rec {
  name = "charles-${version}";
  version = "4.2.6";

  src = fetchurl {
    url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.tar.gz";
    sha256 = "1hjfimyr9nnbbxadwni02d2xl64ybarh42l1g6hlslq5qwl8ywzb";
  };

  installPhase = ''
    set -e

    mkdir -pv $out/bin

    for fn in lib/*.jar; do
      install -D -m644 $fn $out/$fn
    done

    cat > $out/bin/charles << EOF
    #!${stdenv.shell}

    ${jre}/bin/java -Xmx1024M -Dcharles.config="~/.charles.config" -Djava.library.path="$out/lib" -jar $out/lib/charles.jar $*
    EOF

    chmod +x $out/bin/charles

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    for dim in 16x16 32x32 64x64 128x128 256x256 512x512; do
      install -D -m644 icon/$dim/apps/charles-proxy.png \
        $out/share/icons/hicolor/$dim/apps/charles.png
      for mimetype in application-har+json.png application-vnd.tcpdump.pcap.png application-x-charles-savedsession.png application-x-charles-trace.png; do
        install -D -m644 icon/$dim/mimetypes/$mimetype \
          $out/share/icons/hicolor/$dim/mimetypes/$mimetype
      done
    done

    install -D -m644 doc/licenses/bounce-license.txt \
      $out/share/licenses/bounce-license.txt
  '';

  meta = with stdenv.lib; {
    description = "Web Debugging Proxy";
    homepage = https://www.charlesproxy.com/;
    maintainers = [ maintainers.kalbasit ];
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
