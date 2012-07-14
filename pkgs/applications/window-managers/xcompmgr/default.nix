{ stdenv, fetchurl, pkgconfig, libXcomposite, libXfixes, libXdamage
, libXrender, libXext }:
stdenv.mkDerivation rec {
  name = "xcompmgr-1.1.6";
  src = fetchurl {
    url = "http://www.x.org/releases/individual/app/${name}.tar.bz2";
    sha256 = "c98949d36793b30ed1ed47495c87a05fa245ac0fc2857d2abc54979124687c02";
  };
  buildInputs = [ pkgconfig libXcomposite libXfixes libXdamage libXrender libXext ];
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
