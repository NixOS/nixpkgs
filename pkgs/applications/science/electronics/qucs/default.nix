{stdenv, fetchurl, qt3, libX11}:

stdenv.mkDerivation rec {
  name = "qucs-0.0.16";

  src = fetchurl {
    url = "mirror://sourceforge/qucs/${name}.tar.gz";
    sha256 = "1h8ba84k06rix5zl5p9p414zj2facbnlf1vxwh4a1sp4h9dbfnzy";
  };

  patches = [ ./tr1-complex.patch ];
  patchFlags = "-p0";

  buildInputs = [ qt3 libX11 ];

  meta = {
    description = "Integrated circuit simulator";
    homepage = http://qucs.sourceforge.net;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
