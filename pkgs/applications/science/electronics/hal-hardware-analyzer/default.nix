{ lib, stdenv, fetchFromGitHub, cmake, ninja, pkgconfig, python3Packages
, boost, rapidjson, qtbase, qtsvg, igraph, spdlog, wrapQtAppsHook
, fmt, graphviz, llvmPackages ? null
}:

stdenv.mkDerivation rec {
  version = "3.1.9";
  pname = "hal-hardware-analyzer";

  src = fetchFromGitHub {
    owner = "emsec";
    repo = "hal";
    rev = "v${version}";
    sha256 = "0yvvlx0hq73x20va4csa8kyx3x4z648s6l6qqirzjpmxa1w91xc6";
  };
  # make sure bundled dependencies don't get in the way - install also otherwise
  # copies them in full to the output, bloating the package
  postPatch = ''
    shopt -s extglob
    rm -rf deps/!(sanitizers-cmake)/*
    shopt -u extglob
  '';

  nativeBuildInputs = [ cmake ninja pkgconfig ];
  buildInputs = [ qtbase qtsvg boost rapidjson igraph spdlog fmt graphviz wrapQtAppsHook ]
    ++ (with python3Packages; [ python pybind11 ])
    ++ stdenv.lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = with stdenv.lib.versions; [
    "-DHAL_VERSION_RETURN=${version}"
    "-DHAL_VERSION_MAJOR=${major version}"
    "-DHAL_VERSION_MINOR=${minor version}"
    "-DHAL_VERSION_PATCH=${patch version}"
    "-DHAL_VERSION_TWEAK=0"
    "-DHAL_VERSION_ADDITIONAL_COMMITS=0"
    "-DHAL_VERSION_DIRTY=false"
    "-DHAL_VERSION_BROKEN=false"
    "-DENABLE_INSTALL_LDCONFIG=off"
    "-DBUILD_ALL_PLUGINS=on"
  ];
  # needed for macos build - this is why we use wrapQtAppsHook instead of
  # the qt mkDerivation - the latter forcibly overrides this.
  cmakeBuildType = "MinSizeRel";

  meta = with lib; {
    description = "A comprehensive reverse engineering and manipulation framework for gate-level netlists";
    homepage = "https://github.com/emsec/hal";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ris shamilton ];
  };
}
