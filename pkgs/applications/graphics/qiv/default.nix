{ stdenv, fetchurl, pkgconfig, gtk2, imlib2, file, lcms2, libexif } :

stdenv.mkDerivation (rec {
  version = "2.3.2";
  pname = "qiv";

  src = fetchurl {
    url = "https://spiegl.de/qiv/download/${pname}-${version}.tgz";
    sha256 = "1mc0f2nnas4q0d7zc9r6g4z93i32xlx0p9hl4fn5zkyml24a1q28";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 imlib2 file lcms2 libexif ];

  preBuild=''
    substituteInPlace Makefile --replace /usr/local "$out"
    substituteInPlace Makefile --replace /man/ /share/man/
    substituteInPlace Makefile --replace /share/share/ /share/
  '';

  meta = with stdenv.lib; {
    description = "Quick image viewer";
    homepage = "http://spiegl.de/qiv/";
    inherit version;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
})
