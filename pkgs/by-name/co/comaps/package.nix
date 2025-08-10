{
  lib,
  stdenv,
  fetchFromGitea,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  which,
  python3,
  rsync,
  qt6,
  libGLU,
  libGL,
  zlib,
  icu,
  freetype,
  pugixml,
  xorg,
  gflags,
  nix-update-script,
  optipng,
  jansson,
  utf8cpp,
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
  pname = "comaps";
  version = "2025.07.23-4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "comaps";
    repo = "comaps";
    tag = "${finalAttrs.version}-android";
    hash = "sha256-gXqysO88XaWZkX2XGmjMwW7C/+Je5JcW7CD9tCSdgpw=";
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
    qt6.wrapQtAppsHook
    optipng
  ];

  # Most dependencies are vendored
  buildInputs = with qt6; [
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
    gflags
    jansson
    utf8cpp
  ];

  # Yes, this is PRE configure. The configure phase uses cmake
  preConfigure = ''
    bash ./configure.sh --skip-map-download
  '';

  cmakeFlags = [
    (lib.cmakeBool "SKIP_TESTS" true)
    (lib.cmakeBool "WITH_SYSTEM_PROVIDED_3PARTY" true)
  ];

  env.NIX_CFLAGS_COMPILE = "-I/build/source/3party/fast_double_parser/include";

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
    homepage = "https://www.comaps.app/";
    description = "Detailed Offline Maps for Travellers, Tourists, Hikers and Cyclists";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    mainProgram = "OMaps";
  };
})
