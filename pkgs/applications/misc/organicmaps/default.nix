{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, pkg-config
, which
, python3
, rsync
, wrapQtAppsHook
, qtbase
, qtpositioning
, qtsvg
, qtwayland
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
    rev = "30ecb0b3fe694a582edfacc2a7425b6f01f9fec6";
    hash = "sha256-1FF658OhKg8a5kKX/7TVmsxZ9amimn4lB6bX9i7pnI4=";
  };
in stdenv.mkDerivation rec {
  pname = "organicmaps";
  version = "2024.11.12-7";

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    rev = "${version}-android";
    hash = "sha256-uA0KB9HGI0hXoD5YVOfWg3WblpGvWhgpnCVHWfLkrhs=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix for https://github.com/organicmaps/organicmaps/issues/7838
    (fetchpatch {
      url = "https://github.com/organicmaps/organicmaps/commit/1caf64e315c988cd8d5196c80be96efec6c74ccc.patch";
      hash = "sha256-k3VVRgHCFDhviHxduQMVRUUvQDgMwFHIiDZKa4BNTyk=";
    })
  ];

  postPatch = ''
    # Disable certificate check. It's dependent on time
    echo "exit 0" > tools/unix/check_cert.sh

    # crude fix for https://github.com/organicmaps/organicmaps/issues/1862
    echo "echo ${lib.replaceStrings ["." "-"] ["" ""] version}" > tools/unix/version.sh

    # TODO use system boost instead, see https://github.com/organicmaps/organicmaps/issues/5345
    patchShebangs 3party/boost/tools/build/src/engine/build.sh

    # Prefetch test data, or the build system will try to fetch it with git.
    ln -s ${world_feed_integration_tests_data} data/test_data/world_feed_integration_tests_data
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
    qtpositioning
    qtsvg
    qtwayland
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
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://organicmaps.app/";
    description = "Detailed Offline Maps for Travellers, Tourists, Hikers and Cyclists";
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "OMaps";
  };
}
