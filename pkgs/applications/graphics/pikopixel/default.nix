{ lib
, fetchurl
, gnustep
, gcc
, llvmPackages_9
}:

let
  # Earlier llvm than 9 segfaults
  gnustep' = gnustep.override { llvmPackages = llvmPackages_9; };

in gnustep'.gsmakeDerivation rec {
  pname = "pikopixel";
  version = "1.0-b9e";

  src = fetchurl {
    url = "http://twilightedge.com/downloads/PikoPixel.Sources.${version}.tar.gz";
    sha256 = "1gmgb5ch7s6fwvg85l6pl6fsx0maqwd8yvg7sz3r9lj32g2pz5wn";
  };

  sourceRoot = "PikoPixel.Sources.${version}/PikoPixel";

  buildInputs = [
    gnustep'.base
    gnustep'.gui
    gnustep'.back
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
    homepage = "http://twilightedge.com/mac/pikopixel/";
    downloadPage = "http://twilightedge.com/mac/pikopixel/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
