{ stdenv, fetchurl, pkgconfig, ncurses, readline }:

let version = "0.6.0pre2"; in
stdenv.mkDerivation rec {
  name = "abook-${version}";

  src = fetchurl {
    url = "http://abook.sourceforge.net/devel/${name}.tar.gz";
    sha256 = "59d444504109dd96816e003b3023175981ae179af479349c34fa70bc12f6d385";
  };

  buildInputs = [ pkgconfig ncurses readline ];

  meta = {
    homepage = "http://abook.sourceforge.net/";
    description = "Text-based addressbook program designed to use with mutt mail client";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.edwtjo ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
