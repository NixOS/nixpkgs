{ lib, stdenv, fetchFromGitHub
, autoreconfHook
, pkgconfig
, glib
, ronn
, curl
, id3lib
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "castget";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "mlj";
    repo = pname;
    # Upstream uses `_` instead of `.` for the version, let's hope it will
    # change in the next release
    rev = "rel_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "1pfrjmsikv35cc0praxgim26zq4r7dfp1pkn6n9fz3fm73gxylyv";
  };
  # Otherwise, the autoreconfHook fails since Makefile.am requires it
  preAutoreconf = ''
    touch NEWS
    touch README
    touch ChangeLog
  '';

  buildInputs = [ glib curl id3lib libxml2 ];
  nativeBuildInputs = [ ronn autoreconfHook pkgconfig ];

  meta = with stdenv.lib; {
    description = "A simple, command-line based RSS enclosure downloader";
    longDescription = ''
      castget is a simple, command-line based RSS enclosure downloader. It is
      primarily intended for automatic, unattended downloading of podcasts.
    '';
    homepage = "http://castget.johndal.com/";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
