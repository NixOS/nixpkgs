{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, libxml2 }:

stdenv.mkDerivation rec {
  pname = "evtest";
  version = "1.34";

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/${pname}";
    rev = "refs/tags/${pname}-${version}";
    sha256 = "168gdhzj11f4nk94a6z696sm8v1njzwww69bn6wr97l17897913g";
  };

  meta = with lib; {
    description = "Simple tool for input event debugging";
    license = lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
