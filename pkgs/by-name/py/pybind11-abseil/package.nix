{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  abseil-cpp,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pybind11-abseil";
  version = "202402.0";

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11_abseil";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hFVuGzEFqAEm2p2RmfhFtLB6qOqNuVNcwcLh8dIWi0k=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ python3.pkgs.pybind11 ];

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ABSEIL-CPP" "${abseil-cpp.src}")
    (lib.cmakeFeature "CMAKE_INSTALL_PYDIR" "${placeholder "out"}/${python3.sitePackages}")
  ];

  meta = {
    description = "Pybind11 bindings for the Abseil C++ Common Libraries";
    homepage = "https://github.com/pybind/pybind11_abseil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
