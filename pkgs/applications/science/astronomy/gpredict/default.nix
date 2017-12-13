{ stdenv, fetchurl, pkgconfig
, gtk2-x11, glib, curl, goocanvas, intltool
}:

let
  version = "1.3";
in
stdenv.mkDerivation {
  name = "gpredict-${version}";

  src = fetchurl {
    url = "https://sourceforge.net/projects/gpredict/files/Gpredict/${version}/gpredict-${version}.tar.gz";
    sha256 = "18ym71r2f5mwpnjcnrpwrk3py2f6jlqmj8hzp89wbcm1ipnvxxmh";
  };

  buildInputs = [ curl glib gtk2-x11 goocanvas ];
  nativeBuildInputs = [ pkgconfig intltool ];

  meta = with stdenv.lib; {
    description = "Real time satellite tracking and orbit prediction";
    longDescription = ''
      Gpredict is a real time satellite tracking and orbit prediction program
      written using the Gtk+ widgets. Gpredict is targetted mainly towards ham radio
      operators but others interested in satellite tracking may find it useful as
      well. Gpredict uses the SGP4/SDP4 algorithms, which are compatible with the
      NORAD Keplerian elements.
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    homepage = "https://sourceforge.net/projects/gpredict/";
    maintainers = [ maintainers.markuskowa ];
  };
}
