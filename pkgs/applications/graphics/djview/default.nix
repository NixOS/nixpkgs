{ stdenv, fetchurl, pkgconfig, djvulibre, qt4, xorg, libtiff }:

let
  qt = qt4;
  # TODO: qt = qt5.base; # should work but there's a mysterious "-silent" error
in
stdenv.mkDerivation rec {
  name = "djview-4.10.5";
  src = fetchurl {
    url = "mirror://sourceforge/djvu/${name}.tar.gz";
    sha256 = "0gbvbly7w3cr8wgpyh76nf9w7cf7740vp7k5hccks186f6005cx0";
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
