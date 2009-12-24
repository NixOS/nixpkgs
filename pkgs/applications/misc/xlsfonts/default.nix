# This program used to come with xorg releases, but now I could only find it
# at http://www.x.org/releases/individual/.
# That is why this expression is not inside pkgs.xorg

{stdenv, fetchurl, libX11, pkgconfig}:
stdenv.mkDerivation rec {
  name = "xlsfonts-1.0.2";

  src = fetchurl {
    url = "http://www.x.org/releases/individual/app/${name}.tar.bz2";
    sha256 = "070iym754g3mf9x6xczl4gdnpvlk6rdyl1ndwhpjl21vg2dm2vnc";
  };

  buildInputs = [libX11 pkgconfig];

  meta = {
    homepage = http://www.x.org/;
    description = "Lists the fonts available in the X server";
    licesnse = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
