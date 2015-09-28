{ stdenv, fetchurl, pkgconfig, djvulibre, qt4, xorg, libtiff }:

let
  qt = qt4;
  # TODO: qt = qt5.base; # should work but there's a mysterious "-silent" error
in
stdenv.mkDerivation rec {
  name = "djview-4.10.3";
  src = fetchurl {
    url = "mirror://sourceforge/djvu/${name}.tar.gz";
    sha256 = "09dbws0k8giizc0xqpad8plbyaply8x1pjc2k3207v2svk6hxf2h";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ djvulibre qt xorg.libXt libtiff ];

  passthru = {
    mozillaPlugin = "/lib/netscape/plugins";
  };

  meta = with stdenv.lib; {
    homepage = http://djvu.sourceforge.net/djview4.html;
    description = "A portable DjVu viewer and browser plugin";
    license = licenses.gpl2;
    inherit (qt.meta) platforms;
    maintainers = [ maintainers.urkud ];
  };
}
