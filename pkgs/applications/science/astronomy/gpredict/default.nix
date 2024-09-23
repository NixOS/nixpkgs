{ lib, stdenv, fetchurl, fetchpatch, pkg-config, intltool
, gtk3, glib, curl, goocanvas2, gpsd
, hamlib, wrapGAppsHook3
}:

let
  version = "2.2.1";
in stdenv.mkDerivation {
  pname = "gpredict";
  inherit version;

  src = fetchurl {
    url = "https://github.com/csete/gpredict/releases/download/v${version}/gpredict-${version}.tar.bz2";
    sha256 = "0hwf97kng1zy8rxyglw04x89p0bg07zq30hgghm20yxiw2xc8ng7";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains:
    #   https://github.com/csete/gpredict/issues/195
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/csete/gpredict/commit/c565bb3d48777bfe17114b5d01cd81150521f056.patch";
      sha256 = "1jhy9hpqlachq32bkij60q3dxkgi1kkr80rm29jjxqpmambf406a";
    })
  ];

  nativeBuildInputs = [ pkg-config intltool wrapGAppsHook3 ];
  buildInputs = [ curl glib gtk3 goocanvas2 gpsd hamlib ];

  meta = with lib; {
    description = "Real time satellite tracking and orbit prediction";
    mainProgram = "gpredict";
    longDescription = ''
      Gpredict is a real time satellite tracking and orbit prediction program
      written using the GTK widgets. Gpredict is targetted mainly towards ham radio
      operators but others interested in satellite tracking may find it useful as
      well. Gpredict uses the SGP4/SDP4 algorithms, which are compatible with the
      NORAD Keplerian elements.
    '';
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    homepage = "http://gpredict.oz9aec.net/";
    maintainers = [ maintainers.markuskowa maintainers.cmcdragonkai ];
  };
}
