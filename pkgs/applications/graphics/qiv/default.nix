{ stdenv, fetchurl, pkgconfig, gtk, imlib2, file, lcms2, libexif } :

stdenv.mkDerivation (rec {
  version = "2.3.1";
  name = "qiv-${version}";

  src = fetchurl {
    url = "http://spiegl.de/qiv/download/${name}.tgz";
    sha256 = "1rlf5h67vhj7n1y7jqkm9k115nfnzpwngj3kzqsi2lg676srclv7";
  };

  buildInputs = [ pkgconfig gtk imlib2 file lcms2 libexif ];

  preBuild=''
    substituteInPlace Makefile --replace /usr/local "$out"
    substituteInPlace Makefile --replace /man/ /share/man/
  '';

  meta = {
    description = "qiv (quick image viewer)";
    homepage = http://spiegl.de/qiv/;
    inherit version;
  };
})
