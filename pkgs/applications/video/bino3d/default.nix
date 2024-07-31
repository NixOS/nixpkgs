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
  version = "2.2";

  src = fetchgit {
    url = "https://git.marlam.de/git/bino.git";
    rev = "bino-${finalAttrs.version}";
    hash = "sha256-t7bkpYOswGEjUg+k2gjUkWwZJjj44KIVrEQs5P4DoSI=";
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

  # LTO is currently broken on macOS.
  # https://github.com/NixOS/nixpkgs/issues/19098
  cmakeFlags = lib.optionals stdenv.isDarwin [
    (lib.cmakeBool "CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE" false)
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
