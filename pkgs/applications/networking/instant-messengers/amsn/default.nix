{stdenv, fetchurl, which, tcl, tk, xlibsWrapper, libpng, libjpeg, makeWrapper}:

stdenv.mkDerivation {
  name = "amsn-0.98.9";
  src = fetchurl {
    url = mirror://sourceforge/amsn/amsn-0.98.9-src.tar.gz;
    sha256 = "0b8ir7spxnsz8f7kvr9f1k91nsy8cb65q6jv2l55b04fl20x4z7r";
  };

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--enable-static"
  ];

  buildInputs = [which tcl tk xlibsWrapper libpng libjpeg makeWrapper];

  postInstall = ''
    wrapProgram $out/bin/amsn --prefix PATH : ${tk}/bin
  '';

  meta = {
    description = "Instant messaging (MSN Messenger clone)";
    homepage = http://amsn-project.net;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
