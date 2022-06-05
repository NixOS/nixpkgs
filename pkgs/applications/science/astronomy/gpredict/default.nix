{ lib, stdenv, fetchurl, pkg-config, intltool
, gtk3, glib, curl, goocanvas2, gpsd
, hamlib, wrapGAppsHook
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

  nativeBuildInputs = [ pkg-config intltool wrapGAppsHook ];
  buildInputs = [ curl glib gtk3 goocanvas2 gpsd hamlib ];

  meta = with lib; {
    description = "Real time satellite tracking and orbit prediction";
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
