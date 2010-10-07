{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, automoc4, phonon, mlt, gettext,
shared_mime_info, soprano}:

stdenv.mkDerivation {
  name = "kdenlive-0.7.7.1";
  src = fetchurl {
    url = mirror://sourceforge/kdenlive/kdenlive-0.7.7.1.tar.gz;
    sha256 = "047kpzfdmipgnnkbdhcpy5c0kqgpg7yn3qhyd7inlplmyd3i1pfx";
  };

  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon mlt gettext
    shared_mime_info soprano ];

  meta = {
    description = "Free and open source video editor";
    license = "GPLv2+";
    homepage = http://www.kdenlive.org/;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
