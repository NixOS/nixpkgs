{ lib
<<<<<<< HEAD
=======
, mkDerivation
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, which
, python3
, rsync
<<<<<<< HEAD
, wrapQtAppsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qtbase
, qtsvg
, libGLU
, libGL
, zlib
, icu
, freetype
, pugixml
, nix-update-script
}:

<<<<<<< HEAD
let
  world_feed_integration_tests_data = fetchFromGitHub {
    owner = "organicmaps";
    repo = "world_feed_integration_tests_data";
    rev = "3b66e59eaae85ebc583ce20baa3bdf27811349c4";
    hash = "sha256-wOZKqwYxJLllyxCr44rAcropKhohLUIVCtsR5tz9TRw=";
  };
in stdenv.mkDerivation rec {
  pname = "organicmaps";
  version = "2023.08.18-8";
=======
mkDerivation rec {
  pname = "organicmaps";
  version = "2023.04.02-7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    rev = "${version}-android";
<<<<<<< HEAD
    hash = "sha256-vdleO4jNKibyDlqrfZsOCScpQ9zreuYSw2BSoNpmeLY=";
=======
    sha256 = "sha256-xXBzHo7IOo2f1raGnpFcsvs++crHMI5SACIc345cX7g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  postPatch = ''
    # Disable certificate check. It's dependent on time
    echo "exit 0" > tools/unix/check_cert.sh

    # crude fix for https://github.com/organicmaps/organicmaps/issues/1862
    echo "echo ${lib.replaceStrings ["." "-"] ["" ""] version}" > tools/unix/version.sh
<<<<<<< HEAD

    # TODO use system boost instead, see https://github.com/organicmaps/organicmaps/issues/5345
    patchShebangs 3party/boost/tools/build/src/engine/build.sh

    # Prefetch test data, or the build system will try to fetch it with git.
    ln -s ${world_feed_integration_tests_data} data/world_feed_integration_tests_data
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    which
    python3
    rsync
<<<<<<< HEAD
    wrapQtAppsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Most dependencies are vendored
  buildInputs = [
    qtbase
    qtsvg
    libGLU
    libGL
    zlib
    icu
    freetype
    pugixml
  ];

  # Yes, this is PRE configure. The configure phase uses cmake
  preConfigure = ''
    bash ./configure.sh
  '';

  passthru = {
    updateScript = nix-update-script {
<<<<<<< HEAD
=======
      attrPath = pname;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      extraArgs = [ "-vr" "(.*)-android" ];
    };
  };

  meta = with lib; {
    # darwin: "invalid application of 'sizeof' to a function type"
<<<<<<< HEAD
    broken = stdenv.isDarwin;
=======
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://organicmaps.app/";
    description = "Detailed Offline Maps for Travellers, Tourists, Hikers and Cyclists";
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "OMaps";
  };
}
