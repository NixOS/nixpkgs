{ stdenv, fetchFromGitHub, cmake, ninja, pkgconfig, python3Packages
, boost, rapidjson, qtbase, qtsvg, igraph, spdlog, wrapQtAppsHook
, llvmPackages ? null
}:

stdenv.mkDerivation rec {
  version = "2.0.0";
  pname = "hal-hardware-analyzer";

  src = fetchFromGitHub {
    owner = "emsec";
    repo = "hal";
    rev = "v${version}";
    sha256 = "11xmqxnryksl645wmm1d69k1b5zwvxxf0admk4iblzaa3ggf7cv1";
  };
  # make sure bundled dependencies don't get in the way - install also otherwise
  # copies them in full to the output, bloating the package
  postPatch = ''
    rm -rf deps/*/*
    substituteInPlace cmake/detect_dependencies.cmake \
      --replace 'spdlog 1.4.2 EXACT' 'spdlog 1.4.2 REQUIRED'
  '';

  nativeBuildInputs = [ cmake ninja pkgconfig ];
  buildInputs = [ qtbase qtsvg boost rapidjson igraph spdlog wrapQtAppsHook ]
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

  meta = {
    description = "A comprehensive reverse engineering and manipulation framework for gate-level netlists";
    homepage = "https://github.com/emsec/hal";
    license = stdenv.lib.licenses.mit;
    platforms = with stdenv.lib.platforms; unix;
    maintainers = with stdenv.lib.maintainers; [ ris ];
  };
}
