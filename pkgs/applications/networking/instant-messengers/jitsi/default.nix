{ stdenv, fetchurl, makeDesktopItem, unzip, ant, jdk }:

stdenv.mkDerivation rec {

  name = "jitsi-${version}";
  version = "2.4.4997";

  src = fetchurl {
    url = "https://download.jitsi.org/jitsi/src/jitsi-src-${version}.zip";
    sha256 = "f1c2688d7d6bf1916fed3b8b105a785662980c5b297dcab3c9e7d272647ef825";
  };

  patches = [ ./jitsi.patch ];

  jitsiItem = makeDesktopItem {
    name = "Jitsi";
    exec = "jitsi";
    comment = "VoIP and Instant Messaging client";
    desktopName = "Jitsi";
    genericName = "Instant Messaging";
    categories = "Application;Internet;";
  };

  buildInputs = [unzip ant jdk];

  buildPhase = ''ant make'';

  installPhase = ''
    mkdir -p $out
    cp -a lib $out/
    cp -a sc-bundles $out/
    mkdir $out/bin
    cp resources/install/generic/run.sh $out/bin/jitsi
    chmod +x $out/bin/jitsi
    sed -i 's| java | ${jdk}/bin/java |' $out/bin/jitsi
    patchShebangs $out
  '';

  meta = {
    homepage = https://jitsi.org/;
    description = "Open Source Video Calls and Chat";
    license = stdenv.lib.licenses.lgpl21Plus.shortName;
    platforms = stdenv.lib.platforms.linux;
  };

}
