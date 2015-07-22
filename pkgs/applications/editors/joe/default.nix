{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "joe-4.0";

  src = fetchurl {
    url = "mirror://sourceforge/joe-editor/${name}.tar.gz";
    sha256 = "0599xp90idl3dkplz72p33d2rfg0hb5yd38rhqdvz5zxfzzssmn5";
  };

  meta = with stdenv.lib; {
    description = "A full featured terminal-based screen editor";
    homepage = http://joe-editor.sourceforge.net;
    license = licenses.gpl2;
  };
}
