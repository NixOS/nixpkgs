{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  version = "4.6";
  pname = "joe";

  src = fetchurl {
    url = "mirror://sourceforge/joe-editor/${pname}-${version}.tar.gz";
    sha256 = "1pmr598xxxm9j9dl93kq4dv36zyw0q2dh6d7x07hf134y9hhlnj9";
  };

  meta = with stdenv.lib; {
    description = "A full featured terminal-based screen editor";
    homepage = https://joe-editor.sourceforge.io;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
