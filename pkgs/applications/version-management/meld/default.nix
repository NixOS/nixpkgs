{stdenv, fetchurl, pygtk, python, intltool, scrollkeeper, makeWrapper }:

let
  minor = "1.8";
  version = "${minor}.6";
in

stdenv.mkDerivation {
  name = "meld-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/meld/${minor}/meld-${version}.tar.xz";
    sha256 = "19g86rksrs77hd58zhs3zwbjmmhqc98v2ly8451avwsbiwmni5mg";
  };

  buildInputs = [ pygtk python intltool scrollkeeper makeWrapper ];

  patchPhase = ''
    sed -e s,/usr/local,$out, -i INSTALL
    sed -e 's,#!.*,#!${python}/bin/python,' -i bin/meld
  '';

  postInstall = ''
    wrapProgram $out/bin/meld --prefix PYTHONPATH : $PYTHONPATH:${pygtk}/lib/${python.libPrefix}/site-packages/gtk-2.0
  '';

  meta = with stdenv.lib; {
    description = "Visual diff and merge tool";
    homepage = http://meld.sourceforge.net;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
