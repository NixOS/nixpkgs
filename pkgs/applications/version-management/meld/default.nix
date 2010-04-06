{stdenv, fetchurl, pygtk, python, intltool, scrollkeeper, makeWrapper }:

stdenv.mkDerivation {
  name = "meld-1.3.1";

  src = fetchurl {
    url = http://ftp.gnome.org/pub/gnome/sources/meld/1.3/meld-1.3.1.tar.bz2;
    sha256 = "0iqnj3qb9l7z12akgmf64fr2xqirsqxflvj60xqcqr5vd5c763nn";
  };

  buildInputs = [ pygtk python intltool scrollkeeper makeWrapper ];

  patchPhase = ''
    sed -e s,/usr/local,$out, -i INSTALL
    sed -e 's,#!.*,#!${python}/bin/python,' -i meld
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
