{
  stdenv,
  lib,
  fetchgit,
  autoreconfHook,
  libelf,
  libiberty,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "prelink";
  version = "20151030-unstable-2024-07-02";

  src = fetchgit {
    url = "https://git.yoctoproject.org/prelink-cross";
    branchName = "cross_prelink";
    rev = "ff2561c02ade96c5d4d56ddd4e27ff064840a176";
    sha256 = "sha256-wmX7ybrZDWEop9fiInZMvgK/fpEk3sq+Wu8DSWWIvQY=";
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

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "ELF prelinking utility to speed up dynamic linking";
    homepage = "https://wiki.yoctoproject.org/wiki/Cross-Prelink";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
