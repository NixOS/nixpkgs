{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  version = "4.2";
  name = "joe-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/joe-editor/${name}.tar.gz";
    sha256 = "0x39x0qrwdbhl45wd8r8cpzigsip6m5j2crajsrbffk8qm5scpdw";
  };

  meta = with stdenv.lib; {
    description = "A full featured terminal-based screen editor";
    homepage = http://joe-editor.sourceforge.net;
    license = licenses.gpl2;
  };
}
