{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  pkg-config,
  pandoc,
  wrapQtAppsHook,
  qtbase,
  qtmultimedia,
  qttools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bino";
  version = "2.4";

  src = fetchgit {
    url = "https://git.marlam.de/git/bino.git";
    rev = "bino-${finalAttrs.version}";
    hash = "sha256-h7sS+5he8dKl9ipdM1Vs1WC6U+Pi/QMVSdTbT9E59lU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    pandoc
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qttools
    # The optional QVR dependency is not currently packaged.
  ];

  meta = {
    description = "Video player with a focus on 3D and Virtual Reality";
    homepage = "https://bino3d.org/";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.orivej ];
    platforms = lib.platforms.unix;
    mainProgram = "bino";
  };
})
