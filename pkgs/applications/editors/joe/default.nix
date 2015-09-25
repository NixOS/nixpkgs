{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  version = "4.1";
  name = "joe-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/joe-editor/${name}.tar.gz";
    sha256 = "1nznzr9h0rh8g15c56yxzwpn2labx9sgsak0wcnpj7wmpnr12ql1";
  };

  meta = with stdenv.lib; {
    description = "A full featured terminal-based screen editor";
    homepage = http://joe-editor.sourceforge.net;
    license = licenses.gpl2;
  };
}
