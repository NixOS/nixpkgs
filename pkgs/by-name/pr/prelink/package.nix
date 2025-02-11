{
  stdenv,
  lib,
  fetchgit,
  autoreconfHook,
  libelf,
  libiberty,
}:

stdenv.mkDerivation rec {
  pname = "prelink";
  version = "unstable-2019-06-24";

  src = fetchgit {
    url = "https://git.yoctoproject.org/git/prelink-cross";
    branchName = "cross_prelink";
    rev = "f9975537dbfd9ade0fc813bd5cf5fcbe41753a37";
    sha256 = "sha256-O9/oZooLRyUBBZX3SFcB6LFMmi2vQqkUlqtZnrq5oZc=";
  };

  strictDeps = true;

  configurePlatforms = [
    "build"
    "host"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    stdenv.cc.libc
    libelf
    libiberty
  ];

  # most tests fail
  doCheck = false;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "ELF prelinking utility to speed up dynamic linking";
    homepage = "https://wiki.yoctoproject.org/wiki/Cross-Prelink";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
