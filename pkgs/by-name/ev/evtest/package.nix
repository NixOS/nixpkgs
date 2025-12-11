{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "evtest";
  version = "1.36";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/${pname}";
    rev = "refs/tags/${pname}-${version}";
    sha256 = "sha256-M7AGcHklErfRIOu64+OU397OFuqkAn4dqZxx7sDfklc=";
  };

  meta = {
    description = "Simple tool for input event debugging";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
    mainProgram = "evtest";
  };
}
