{ stdenv, fetchurl, makeDesktopItem, unzip, jre }:

stdenv.mkDerivation rec {
  name = "swingsane-${version}";
  version = "0.2";

  src = fetchurl {
    sha256 = "15pgqgyw46yd2i367ax9940pfyvinyw2m8apmwhrn0ix5nywa7ni";
    url = "mirror://sourceforge/swingsane/swingsane-${version}-bin.zip";
  };

  nativeBuildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = let

    execWrapper = ''
      #!/bin/sh
      exec ${jre}/bin/java -jar $out/share/java/swingsane/swingsane-${version}.jar "$@"
    '';

    desktopItem = makeDesktopItem {
      name = "swingsane";
      exec = "swingsane";
      icon = "swingsane";
      desktopName = "SwingSane";
      genericName = "Scan from local or remote SANE servers";
      comment = meta.description;
      categories = "Office;Application;";
    };

  in ''
    install -v -m 755    -d $out/share/java/swingsane/
    install -v -m 644 *.jar $out/share/java/swingsane/

    echo "${execWrapper}" > swingsane
    install -v -D -m 755 swingsane $out/bin/swingsane

    unzip -j swingsane-${version}.jar "com/swingsane/images/*.png"
    install -v -D -m 644 swingsane_512x512.png $out/share/pixmaps/swingsane.png

    cp -v -r ${desktopItem}/share/applications $out/share
  '';

  meta = with stdenv.lib; {
    description = "Java GUI for SANE scanner servers (saned)";
    longDescription = ''
      SwingSane is a powerful, cross platform, open source Java front-end for
      using both local and remote Scanner Access Now Easy (SANE) servers.
      The most powerful feature is its ability to query back-ends for scanner
      specific options which can be set by the user as a scanner profile.
      It also has support for authentication, mutlicast DNS discovery,
      simultaneous scan jobs, image transformation jobs (deskew, binarize,
      crop, etc), PDF and PNG output.
    '';
    homepage = http://swingsane.com/;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };
}
