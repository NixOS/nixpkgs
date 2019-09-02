{
stdenv
, makeWrapper
, makeDesktopItem
, fetchurl
, jre
}:

let
  generic = { version, sha256, ... }@attrs:
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

    attrs' = builtins.removeAttrs attrs ["version" "sha256"];
    in stdenv.mkDerivation rec {
      name = "charles-${version}";
      inherit version;

      src = fetchurl {
        url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.tar.gz";
        inherit sha256;
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
    };

in rec {
  charles4 = (generic {
    version = "4.2.7";
    sha256 = "1nycw3wpbfwj4ijjaq5k0f4xipj8j605fs0yjzgl66gmv7r583rd";
  });
  charles3 = (generic {
    version = "3.12.3";
    sha256 = "13zk82ny1w5zd9qcs9qkq0kdb22ni5byzajyshpxdfm4zv6p32ss";
  });
}

