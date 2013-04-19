{stdenv, fetchurl, pygtk, python, intltool, scrollkeeper, makeWrapper }:

let
  minor = "1.6";
  version = "${minor}.1";
in

stdenv.mkDerivation {
  name = "meld-${version}";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/gnome/sources/meld/${minor}/meld-${version}.tar.xz";
    sha256 = "00rsff0yl5qwzh0igkdns6ry2xsbxad70avpqpkbd2bldi94v76y";
  };

  buildInputs = [ pygtk python intltool scrollkeeper makeWrapper ];

  patchPhase = ''
    sed -e s,/usr/local,$out, -i INSTALL
    sed -e 's,#!.*,#!${python}/bin/python,' -i bin/meld
  '';

  postInstall = ''
    wrapProgram $out/bin/meld --prefix PYTHONPATH : $PYTHONPATH:${pygtk}/lib/${python.libPrefix}/site-packages/gtk-2.0
  '';

  meta = {
    description = "Visual diff and merge tool";
    homepage = http://meld.sourceforge.net;
    license = "GPLv2+";
  };
}
