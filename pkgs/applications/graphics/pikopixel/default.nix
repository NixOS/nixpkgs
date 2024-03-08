{ lib
, fetchurl
, gnustep
}:

gnustep.gsmakeDerivation rec {
  pname = "pikopixel";
  version = "1.0-b10";

  src = fetchurl {
    url = "https://twilightedge.com/downloads/PikoPixel.Sources.${version}.tar.gz";
    sha256 = "1b27npgsan2nx1p581b9q2krx4506yyd6s34r4sf1r9x9adshm77";
  };

  sourceRoot = "PikoPixel.Sources.${version}/PikoPixel";

  buildInputs = [
    gnustep.base
    gnustep.gui
    gnustep.back
  ];

  # Fix the Exec and Icon paths in the .desktop file, and save the file in the
  # correct place.
  # postInstall gets redefined in gnustep.make's builder.sh, so we use preFixup
  preFixup = ''
    mkdir -p $out/share/applications
    sed \
      -e "s@^Exec=.*\$@Exec=$out/bin/PikoPixel %F@" \
      -e "s@^Icon=.*/local@Icon=$out@" \
      PikoPixel.app/Resources/PikoPixel.desktop > $out/share/applications/PikoPixel.desktop
  '';

  meta = with lib; {
    description = "Application for drawing and editing pixel-art images";
    homepage = "https://twilightedge.com/mac/pikopixel/";
    downloadPage = "https://twilightedge.com/mac/pikopixel/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
