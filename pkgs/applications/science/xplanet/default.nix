{stdenv, fetchurl, lib, pkgconfig, freetype, pango, libpng, libtiff, giflib, libjpeg}:

stdenv.mkDerivation {
  name = "xplanet-1.2.1";

  src = fetchurl {
    url = mirror://sourceforge/xplanet/xplanet-1.2.1.tar.gz;
    sha256 = "1pp55a1rgjkfcrwc00y3l48fhpqcp3qagd1zbym6zg27fzi5fbgm";
  };

  patches = 
    [ # Build on GCC 4.4.
      (fetchurl {
        url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/x11-misc/xplanet/files/xplanet-1.2.1-gentoo.patch?rev=1.1";
        sha256 = "0mmagjizj4hj057qmpi45w95zlrqda32x96xy44f6126xzj02yd5";
      })
    ];

  buildInputs = [ pkgconfig freetype pango libpng libtiff giflib libjpeg ];

  meta = {
    description = "Renders an image of the earth or other planets into the X root window";
    homepage = http://xplanet.sourceforge.net;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
