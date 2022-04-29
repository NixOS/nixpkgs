{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, libxml2 }:

stdenv.mkDerivation rec {
  pname = "evtest";
  version = "1.34";

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/${pname}";
    rev = "refs/tags/${pname}-${version}";
    sha256 = "sha256-0UGcoGkNF/19aSTWNEFAmZP7seL/yObXsOLlZLiyG2Q=";
  };

  meta = with lib; {
    description = "Simple tool for input event debugging";
    license = lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
