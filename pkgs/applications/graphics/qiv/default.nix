{ stdenv, fetchurl, pkgconfig, gtk2, imlib2, file, lcms2, libexif } :

stdenv.mkDerivation (rec {
  version = "2.3.1";
  name = "qiv-${version}";

  src = fetchurl {
    url = "https://spiegl.de/qiv/download/${name}.tgz";
    sha256 = "1rlf5h67vhj7n1y7jqkm9k115nfnzpwngj3kzqsi2lg676srclv7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 imlib2 file lcms2 libexif ];

  preBuild=''
    substituteInPlace Makefile --replace /usr/local "$out"
    substituteInPlace Makefile --replace /man/ /share/man/
  '';

  meta = with stdenv.lib; {
    description = "Quick image viewer";
    homepage = http://spiegl.de/qiv/;
    inherit version;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
})
