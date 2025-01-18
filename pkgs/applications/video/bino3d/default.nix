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
  version = "2.3";

  src = fetchgit {
    url = "https://git.marlam.de/git/bino.git";
    rev = "bino-${finalAttrs.version}";
    hash = "sha256-3DnEVde7LzaQUMhPi/RosRIW9j8bbkPVkihO5swCbws=";
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

  meta = with lib; {
    description = "Video player with a focus on 3D and Virtual Reality";
    homepage = "https://bino3d.org/";
    sourceProvenance = [ sourceTypes.fromSource ];
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.orivej ];
    platforms = platforms.unix;
    mainProgram = "bino";
  };
})
