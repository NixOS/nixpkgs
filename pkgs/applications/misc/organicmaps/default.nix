{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  which,
  python3,
  rsync,
  wrapQtAppsHook,
  qtbase,
  qtpositioning,
  qtsvg,
  qtwayland,
  libGLU,
  libGL,
  zlib,
  icu,
  freetype,
  pugixml,
  xorg,
  nix-update-script,
}:

let
  world_feed_integration_tests_data = fetchFromGitHub {
    owner = "organicmaps";
    repo = "world_feed_integration_tests_data";
    rev = "30ecb0b3fe694a582edfacc2a7425b6f01f9fec6";
    hash = "sha256-1FF658OhKg8a5kKX/7TVmsxZ9amimn4lB6bX9i7pnI4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "organicmaps";
  version = "2025.09.01-6";

  src = fetchFromGitHub {
    owner = "organicmaps";
    repo = "organicmaps";
    tag = "${finalAttrs.version}-android";
    hash = "sha256-wxJgfvZvksW/U3ZC7/apRHQTcGvfdi8mYTPCzT8FM3U=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Disable certificate check. It's dependent on time
    echo "exit 0" > tools/unix/check_cert.sh

    # crude fix for https://github.com/organicmaps/organicmaps/issues/1862
    echo "echo ${lib.replaceStrings [ "." "-" ] [ "" "" ] finalAttrs.version}" > tools/unix/version.sh

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
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
  ];

  # Yes, this is PRE configure. The configure phase uses cmake
  preConfigure = ''
    bash ./configure.sh
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "-vr"
        "(.*)-android"
      ];
    };
  };

  meta = {
    # darwin: "invalid application of 'sizeof' to a function type"
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://organicmaps.app/";
    description = "Detailed Offline Maps for Travellers, Tourists, Hikers and Cyclists";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    mainProgram = "OMaps";
  };
})
