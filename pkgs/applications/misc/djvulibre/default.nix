{ stdenv
, fetchurl
, libjpeg
, libtiff
, librsvg
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "djvulibre";
  version = "3.5.27";

  src = fetchurl {
    url = "mirror://sourceforge/djvu/${pname}-${version}.tar.gz";
    sha256 = "0psh3zl9dj4n4r3lx25390nx34xz0bg0ql48zdskhq354ljni5p6";
  };

  outputs = [ "bin" "dev" "out" ];

  buildInputs = [
    libjpeg
    libtiff
    librsvg
    libiconv
  ];

  meta = with stdenv.lib; {
    description = "The big set of CLI tools to make/modify/optimize/show/export DJVU files";
    homepage = "http://djvu.sourceforge.net";
    license = licenses.gpl2;
    maintainers = with maintainers; [ Anton-Latukha ];
    platforms = platforms.all;
  };
}
