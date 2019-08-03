{ stdenv, fetchurl, imake, gccmakedep, xlibsWrapper }:

stdenv.mkDerivation rec {
  version_name = "1.2.sakura.5";
  version = "1.2.5";
  name = "oneko-${version}";
  src = fetchurl {
    url = "http://www.daidouji.com/oneko/distfiles/oneko-${version_name}.tar.gz";
    sha256 = "2c2e05f1241e9b76f54475b5577cd4fb6670de058218d04a741a04ebd4a2b22f";
  };
  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [ xlibsWrapper ];

  makeFlags = [ "BINDIR=$(out)/bin" "MANPATH=$(out)/share/man" ];
  installTargets = "install install.man";

  meta = with stdenv.lib; {
    description = "Creates a cute cat chasing around your mouse cursor";
    longDescription = ''
    Oneko changes your mouse cursor into a mouse
    and creates a little cute cat, which starts
    chasing around your mouse cursor.
    When the cat is done catching the mouse, it starts sleeping.
    '';
    homepage = "http://www.daidouji.com/oneko/";
    license = licenses.publicDomain;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.unix;
  };
}
