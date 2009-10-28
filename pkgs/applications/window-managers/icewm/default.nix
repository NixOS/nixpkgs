args: with args;

stdenv.mkDerivation {
  name = "icewm-1.2.32";

  buildInputs = [ gettext libX11 libXft libXext libXinerama libXrandr libjpeg libtiff libungif libpng imlib ];

  src = fetchurl {
    url = http://mesh.dl.sourceforge.net/sourceforge/icewm/icewm-1.2.32.tar.gz;
    sha256 = "c2fe6ef0bdc0a9f841ae6fe214c06a15d666f90df027d105305f3e0dc109a667";
  };

  meta = {
    description = "A window manager for the X Window System";
    homepage = http://www.icewm.org/;
  };
}
