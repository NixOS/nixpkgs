{stdenv, fetchurl, x11, xineLib, libpng}:

stdenv.mkDerivation {
  name = "xine-ui-0.99.4";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/xine/xine-ui-0.99.4.tar.gz;
    md5 = "90ea1f76747e9788a30a73e7f4a76cf6";
  };
  buildInputs = [
    x11 xineLib libpng
    (if xineLib.xineramaSupport then xineLib.libXinerama else null)
  ];
  configureFlags = "--without-readline";
}
