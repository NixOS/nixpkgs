{
  lib,
  stdenv,
  boost,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  graphviz,
  igraph,
  llvmPackages,
  ninja,
  nlohmann_json,
  pkg-config,
  python3Packages,
  qtbase,
  qtsvg,
  quazip,
  rapidjson,
  spdlog,
  verilator,
  wrapQtAppsHook,
  z3,
}:

stdenv.mkDerivation rec {
  version = "4.4.1";
  pname = "hal-hardware-analyzer";

  src = fetchFromGitHub {
    owner = "emsec";
    repo = "hal";
    rev = "v${version}";
    sha256 = "sha256-8kmYeqsmqR7tY044rZb3KuEAVGv37IObX6k1qjXWG0A=";
  };

  patches = [
    (fetchpatch {
      name = "de-vendor-nlohmann-json.patch";
      # https://github.com/emsec/hal/pull/596
      url = "https://github.com/emsec/hal/commit/f8337d554d80cfa2588512696696fd4c878dd7a3.patch";
      hash = "sha256-QjgvcduwbFccC807JFOevlTfO3KiL9T3HSqYmh3sXAQ=";
    })
    (fetchpatch {
      name = "fix-vendored-igraph-regression.patch";
      # https://github.com/emsec/hal/pull/596
      url = "https://github.com/emsec/hal/commit/fe1fe74719ab4fef873a22e2b28cce0c57d570e0.patch";
      hash = "sha256-bjbW4pr04pP0TCuSdzPcV8h6LbLWMvdGSf61RL9Ju6E=";
    })
    ./4.4.1-newer-spdlog-fmt-compat.patch
  ];

  # make sure bundled dependencies don't get in the way - install also otherwise
  # copies them in full to the output, bloating the package
  postPatch = ''
    shopt -s extglob
    rm -rf deps/!(abc|sanitizers-cmake|subprocess)/*
    shopt -u extglob
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs =
    [
      qtbase
      qtsvg
      boost
      rapidjson
      igraph
      nlohmann_json
      spdlog
      graphviz
      verilator
      z3
      quazip
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

  meta = with lib; {
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
