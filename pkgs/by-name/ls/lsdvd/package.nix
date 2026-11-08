{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  libdvdread,
  libxml2,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsdvd";
  version = "0.21";
  src = fetchgit {
    url = "https://git.code.sf.net/p/lsdvd/git";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-NCMd0gj8jF0xpixMz3Vp77O+vG/Qso98HxFwoB+b3Zc=";
  };

  patches = [
    ./fix-clang-build.patch
  ];

  buildInputs = [
    libdvdread
    libxml2
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://sourceforge.net/projects/lsdvd/";
    description = "Display information about audio, video, and subtitle tracks on a DVD";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ booxter ];
    platforms = lib.platforms.unix;
    mainProgram = "lsdvd";
  };
})
