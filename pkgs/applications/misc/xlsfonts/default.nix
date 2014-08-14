# This program used to come with xorg releases, but now I could only find it
# at http://www.x.org/releases/individual/.
# That is why this expression is not inside pkgs.xorg

{stdenv, fetchurl, libX11, pkgconfig}:
stdenv.mkDerivation rec {
  name = "xlsfonts-1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/app/${name}.tar.bz2";
    sha256 = "1lhcx600z9v65nk93xaxfzi79bm4naynabb52gz1vy1bxj2r25r8";
  };

  buildInputs = [libX11 pkgconfig];

  meta = {
    homepage = http://www.x.org/;
    description = "Lists the fonts available in the X server";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
