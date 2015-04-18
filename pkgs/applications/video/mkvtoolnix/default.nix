{ stdenv, fetchurl
, libmatroska
, flac
, libvorbis
, file
, boost
, xdg_utils
, expat
, withGUI ? true
, wxGTK
, zlib
, ruby
, gettext
, pkgconfig
, curl
}:

assert withGUI -> wxGTK != null;

stdenv.mkDerivation rec {
  version = "7.8.0";
  name = "mkvtoolnix-${version}";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/mkvtoolnix/sources/${name}.tar.xz";
    sha256 = "0m7y9115bkfsm95hv2nq0hnd9w73jymsm071jm798w11vdskm8af";
  };

  buildInputs = [
    libmatroska flac libvorbis file boost xdg_utils
    expat zlib ruby gettext pkgconfig curl
    ] ++ stdenv.lib.optional withGUI wxGTK;

  configureFlags = "--with-boost-libdir=${boost.lib}/lib";
  buildPhase = ''
    ruby ./drake
  '';

  installPhase = ''
    ruby ./drake install
  '';

  meta = {
    description = "Cross-platform tools for Matroska";
    homepage = http://www.bunkus.org/videotools/mkvtoolnix/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
