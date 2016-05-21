{ stdenv, fetchgit, autoreconfHook, automake, pkgconfig, libxml2 }:

stdenv.mkDerivation rec {
  name = "evtest-1.33";

  buildInputs = [ autoreconfHook pkgconfig libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/evtest";
    rev = "refs/tags/evtest-1.33";
    sha256 = "02znrf3y1gwrcm2l8w3063zi2vp05vschhv4cxd4j3ygndvcqxiz";
  };

  meta = with stdenv.lib; {
    description = "Simple tool for input event debugging";
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
