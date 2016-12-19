{ stdenv, fetchgit, autoreconfHook, automake, pkgconfig, libxml2 }:

stdenv.mkDerivation rec {
  name = "evtest-1.33";

  buildInputs = [ autoreconfHook pkgconfig libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/evtest";
    rev = "refs/tags/evtest-1.33";
    sha256 = "168gdhzj11f4nk94a6z696sm8v1njzwww69bn6wr97l17897913g";
  };

  meta = with stdenv.lib; {
    description = "Simple tool for input event debugging";
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
