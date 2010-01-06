{ stdenv, fetchurl, pkgconfig, libXcomposite, libXfixes, libXdamage
, libXrender }:
stdenv.mkDerivation rec {
  name = "xcompmgr-1.1.5";
  src = fetchurl {
    url = "http://www.x.org/releases/individual/app/${name}.tar.bz2";
    sha256 = "bb20737a6f9e0cdf5cfbd5288b6a9a4b16ca18d2be19444549c1d6be2a90b571";
  };
  buildInputs = [ pkgconfig libXcomposite libXfixes libXdamage libXrender ];
  meta = {
    homepage = http://www.x.org/;
    description = "A sample compositing manager for X servers";
    longDescription = ''
      A sample compositing manager for X servers supporting the XFIXES,
      DAMAGE, RENDER, and COMPOSITE extensions.  It enables basic eye-candy
      effects.
    '';
    license = "bsd";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
