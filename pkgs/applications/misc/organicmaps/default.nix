{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, which
, python3
, rsync
, wrapQtAppsHook
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

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    rev = "${version}-android";
    hash = "sha256-vdleO4jNKibyDlqrfZsOCScpQ9zreuYSw2BSoNpmeLY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Disable certificate check. It's dependent on time
    echo "exit 0" > tools/unix/check_cert.sh

    # crude fix for https://github.com/organicmaps/organicmaps/issues/1862
    echo "echo ${lib.replaceStrings ["." "-"] ["" ""] version}" > tools/unix/version.sh

    # TODO use system boost instead, see https://github.com/organicmaps/organicmaps/issues/5345
    patchShebangs 3party/boost/tools/build/src/engine/build.sh

    # Prefetch test data, or the build system will try to fetch it with git.
    ln -s ${world_feed_integration_tests_data} data/world_feed_integration_tests_data
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    which
    python3
    rsync
    wrapQtAppsHook
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
      extraArgs = [ "-vr" "(.*)-android" ];
    };
  };

  meta = with lib; {
    # darwin: "invalid application of 'sizeof' to a function type"
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    homepage = "https://organicmaps.app/";
    description = "Detailed Offline Maps for Travellers, Tourists, Hikers and Cyclists";
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "OMaps";
  };
}
