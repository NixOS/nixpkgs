{ stdenv, fetchgit, autoreconfHook, automake, pkgconfig, libxml2 }:

stdenv.mkDerivation rec {
  name = "evtest-1.32";

  buildInputs = [ autoreconfHook pkgconfig libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/evtest";
    rev = "refs/tags/evtest-1.32";
    sha256 = "150lb7d2gnkcqgfw1hcnb8lcvdb52fpig9j9qxjizp6irhlw2a31";
  };

  meta = with stdenv.lib; {
    description = "Simple tool for input event debugging";
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
