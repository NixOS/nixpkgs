{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  version = "4.4";
  name = "joe-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/joe-editor/${name}.tar.gz";
    sha256 = "0y898r1xlrv75m00y598rvwwsricabplyh80wawsqafapcl4hw55";
  };

  meta = with stdenv.lib; {
    description = "A full featured terminal-based screen editor";
    homepage = http://joe-editor.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
