{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  curl,
  gz-cmake,
  gz-common,
  gz-math,
  gz-msgs,
  gz-tools,
  gz-utils,
  jsoncpp,
  libuuid,
  libyaml,
  libzip,
  protobuf,
  python3,
  spdlog,
  tinyxml-2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-fuel-tools";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-fuel-tools";
    rev = "gz-fuel-tools${lib.head (lib.splitString "." finalAttrs.version)}_${finalAttrs.version}";
    hash = "sha256-9WskZnci7D09aW32lzmdtlhRBM+hcmhG6iNgf3OC1js=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config

    # For standard CMake module FindPackageHandleStandardArgs.cmake
    python3
  ];

  buildInputs = [
    curl
    gz-cmake
    gz-common
    gz-math
    gz-msgs
    gz-tools
    gz-utils
    jsoncpp
    libyaml
    libzip
    protobuf
    tinyxml-2

    # For gz-common6-targets.cmake provided by gz-common
    libuuid
    spdlog
  ];

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Client library and command line tools for interacting with Gazebo Fuel servers";
    homepage = "https://github.com/gazebosim/gz-fuel-tools";
    changelog = "https://github.com/gazebosim/gz-fuel-tools/blob/${finalAttrs.src.rev}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    mainProgram = "gz-fuel-tools";
    platforms = lib.platforms.all;
  };
})
