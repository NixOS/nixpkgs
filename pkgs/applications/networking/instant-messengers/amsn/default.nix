{stdenv, fetchurl, which, tcl, tk, x11, libpng, libjpeg, makeWrapper}:

stdenv.mkDerivation {
  name = "amsn-0.98.4";
  src = fetchurl {
    url = mirror://sourceforge/amsn/amsn-0.98.4-src.tar.gz;
    sha256 = "1kcn1hc6bvgy4svf5l3j5psdrvsmy0p3r33fn7gzcinqdf3xfgqx";
  };

  configureFlags = "--with-tcl=${tcl}/lib --with-tk=${tk}/lib --enable-static";

  buildInputs = [which tcl tk x11 libpng libjpeg makeWrapper];

  postInstall = ''
    wrapProgram $out/bin/amsn --prefix PATH : ${tk}/bin
  '';

  meta = {
    description = "Instant messaging (MSN Messenger clone)";
    homepage = http://amsn-project.net;
  };
}
