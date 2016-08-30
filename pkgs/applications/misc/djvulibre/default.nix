{ stdenv, fetchurl, libjpeg, libtiff, librsvg, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "djvulibre-3.5.27";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${name}.tar.gz";
    sha256 = "0psh3zl9dj4n4r3lx25390nx34xz0bg0ql48zdskhq354ljni5p6";
  };

  outputs = [ "bin" "dev" "out" ];

  buildInputs = [ libjpeg libtiff librsvg ] ++ libintlOrEmpty;

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = with stdenv.lib; {
    description = "A library and viewer for the DJVU file format for scanned images";
    homepage = http://djvu.sourceforge.net;
    license = licenses.gpl2;
    maintainers = with maintainers; [ urkud ];
    platforms = platforms.all;
  };
}
