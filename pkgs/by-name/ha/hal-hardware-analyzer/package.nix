{
  lib,
  stdenv,
  boost,
  cmake,
  fetchFromGitHub,
  graphviz,
  igraph,
  llvmPackages,
  ninja,
  nlohmann_json,
  pkg-config,
  python3Packages,
  libsForQt5,
  rapidjson,
  spdlog,
  verilator,
  z3,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  version = "4.5.0";
  pname = "hal-hardware-analyzer";

  src = fetchFromGitHub {
    owner = "emsec";
    repo = "hal";
    tag = "v${version}";
    hash = "sha256-4HLM/7JCDxWRWusGL4lUa8KXCn9pe3Vkr+lOxHOraNU=";
  };

  # make sure bundled dependencies don't get in the way - install also otherwise
  # copies them in full to the output, bloating the package
  postPatch = ''
    shopt -s extglob
    rm -rf deps/!(abc|sanitizers-cmake|subprocess)/*
    shopt -u extglob
    # https://github.com/emsec/hal/issues/602
    sed -i 1i'#include <algorithm>' include/hal_core/utilities/utils.h
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
    boost
    rapidjson
    igraph
    nlohmann_json
    spdlog
    graphviz
    verilator
    z3
    libsForQt5.quazip
  ]
  ++ (with python3Packages; [
    python
    pybind11
  ])
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = with lib.versions; [
    "-DHAL_VERSION_RETURN=${version}"
    "-DHAL_VERSION_MAJOR=${major version}"
    "-DHAL_VERSION_MINOR=${minor version}"
    "-DHAL_VERSION_PATCH=${patch version}"
    "-DHAL_VERSION_TWEAK=0"
    "-DHAL_VERSION_ADDITIONAL_COMMITS=0"
    "-DHAL_VERSION_DIRTY=false"
    "-DHAL_VERSION_BROKEN=false"
    "-DENABLE_INSTALL_LDCONFIG=off"
    "-DUSE_VENDORED_PYBIND11=off"
    "-DUSE_VENDORED_SPDLOG=off"
    "-DUSE_VENDORED_QUAZIP=off"
    "-DUSE_VENDORED_IGRAPH=off"
    "-DUSE_VENDORED_NLOHMANN_JSON=off"
    "-DBUILD_ALL_PLUGINS=on"
  ];
  # needed for macos build - this is why we use wrapQtAppsHook instead of
  # the qt mkDerivation - the latter forcibly overrides this.
  cmakeBuildType = "MinSizeRel";

  # https://github.com/emsec/hal/issues/598
  NIX_CFLAGS_COMPILE = lib.optional stdenv.hostPlatform.isAarch64 "-flax-vector-conversions";

  # some plugins depend on other plugins and need to be able to load them
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    find $out/lib/hal_plugins -name '*.so*' | while read -r f ; do
      patchelf --set-rpath "$(patchelf --print-rpath "$f"):$out/lib/hal_plugins" "$f"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/emsec/hal/blob/${src.tag}/CHANGELOG.md";
    description = "Comprehensive reverse engineering and manipulation framework for gate-level netlists";
    mainProgram = "hal";
    homepage = "https://github.com/emsec/hal";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      ris
      shamilton
    ];
  };
}
