{stdenv, fetchurl, pygtk, python, intltool, scrollkeeper, makeWrapper }:

let
  minor = "1.5";
  version = "${minor}.0";
in

stdenv.mkDerivation {
  name = "meld-${version}";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/gnome/sources/meld/${minor}/meld-${version}.tar.bz2";
    sha256 = "1kf0k3813nfmahn2l2lbs6n9zg2902gixypsf656m6mqyyrmxrrm";
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
