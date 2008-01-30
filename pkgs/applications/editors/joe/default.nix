{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "joe-3.3";
  src = fetchurl {
    url = mirror://sourceforge/joe-editor/joe-3.3.tar.gz;
    md5 = "02221716679c039c5da00c275d61dbf4";
  };

  meta = {
    homepage = http://joe-editor.sourceforge.net;
  };
}
