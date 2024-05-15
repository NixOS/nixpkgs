{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, ffmpeg
, kdePackages
, kdsingleapplication
, openssl
, pipewire
, taglib
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fooyin";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ludouzi";
    repo = "fooyin";
    rev = "v" + finalAttrs.version;
    hash = "sha256-lvqnFuZMM1Z7rGW63bVRbradtqIX+QPPvsQZ70s/3YU=";
  };

  buildInputs = [
    alsa-lib
    ffmpeg
    kdsingleapplication
    pipewire
    kdePackages.qcoro
    kdePackages.qtbase
    kdePackages.qtsvg
    taglib
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" (finalAttrs.doCheck or false))
    # we need INSTALL_FHS to be true as the various artifacts are otherwise just dumped in the root
    # of $out and the fixupPhase cleans things up anyway
    (lib.cmakeBool "INSTALL_FHS" true)
  ];

  env.LANG = "C.UTF-8";

  meta = with lib; {
    description = "A customisable music player";
    mainProgram = "fooyin";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
})
