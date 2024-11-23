{ lib
, stdenv
, makeWrapper
, makeDesktopItem
, fetchurl
, jdk11
, jdk8
}:

let
  generic = { version, sha256, platform ? "", jdk, ... }@attrs:
  let
    desktopItem = makeDesktopItem {
      categories = [ "Network" "Development" "WebDevelopment" "Java" ];
      desktopName = "Charles";
      exec = "charles %F";
      genericName  = "Web Debugging Proxy";
      icon = "charles-proxy";
      mimeTypes = [
        "application/x-charles-savedsession"
        "application/x-charles-savedsession+xml"
        "application/x-charles-savedsession+json"
        "application/har+json"
        "application/vnd.tcpdump.pcap"
        "application/x-charles-trace"
      ];
      name = "Charles";
      startupNotify = true;
    };

  in stdenv.mkDerivation {
      pname = "charles";
      inherit version;

      src = fetchurl {
        url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}${platform}.tar.gz";
        curlOptsList = [ "--user-agent" "Mozilla/5.0" ]; # HTTP 104 otherwise
        inherit sha256;
      };
      nativeBuildInputs = [ makeWrapper ];

      installPhase = ''
        makeWrapper ${jdk}/bin/java $out/bin/charles \
          --add-flags "-Xmx1024M -Dcharles.config='~/.charles.config' -jar $out/share/java/charles.jar"

        for fn in lib/*.jar; do
          install -D -m644 $fn $out/share/java/$(basename $fn)
        done

        mkdir -p $out/share/applications
        ln -s ${desktopItem}/share/applications/* $out/share/applications/

        mkdir -p $out/share/icons
        cp -r icon $out/share/icons/hicolor
      '';

      meta = with lib; {
        description = "Web Debugging Proxy";
        homepage = "https://www.charlesproxy.com/";
        maintainers = with maintainers; [ kalbasit kashw2 ];
        sourceProvenance = with sourceTypes; [ binaryBytecode ];
        license = licenses.unfree;
        platforms = platforms.unix;
      };
    };

in {
  charles4 = (generic {
    version = "4.6.4";
    sha256 = "KEQYb90kt41dS3TJLZqdaV9P3mQA9UPsEyiFb/knm3w=";
    platform = "_amd64";
    jdk = jdk11;
  });
  charles3 = (generic {
    version = "3.12.3";
    sha256 = "13zk82ny1w5zd9qcs9qkq0kdb22ni5byzajyshpxdfm4zv6p32ss";
    jdk = jdk8.jre;
    mainProgram = "charles";
  });
}
