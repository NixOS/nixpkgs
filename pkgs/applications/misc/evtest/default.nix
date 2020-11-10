{ stdenv, fetchgit, autoreconfHook, pkgconfig, libxml2 }:

stdenv.mkDerivation rec {
  pname = "evtest";
  version = "1.34";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/${pname}";
    rev = "refs/tags/${pname}-${version}";
    sha256 = "168gdhzj11f4nk94a6z696sm8v1njzwww69bn6wr97l17897913g";
  };

  meta = with stdenv.lib; {
    description = "Simple tool for input event debugging";
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
