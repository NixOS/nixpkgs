{ stdenv, fetchurl, pkgconfig, glib, libX11, libXinerama }:

stdenv.mkDerivation rec {
  name = "herbstluftwm-0.5.2";

  src = fetchurl {
    url = "http://herbstluftwm.org/tarballs/${name}.tar.gz";
    sha256 = "15crb77gw8p1h721r3dcgn0m1n03qk0g81rrnaqw8p7hz44k6gf5";
  };

  patchPhase = ''
      sed -i -e "s:/usr/local:$\{out}:" \
             -e "s:/etc:$\{out}/etc:" \
          config.mk
  '';

  buildInputs = [ pkgconfig glib libX11 libXinerama ];

  meta = {
    description = "A manual tiling window manager for X";
    homepage = "http://herbstluftwm.org/";
    license = "BSD"; # Simplified BSD License
    platforms = stdenv.lib.platforms.linux;
  };
}
