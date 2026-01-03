{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  abseil-cpp_202505,
  protobuf,
  pybind11,
  zlib,
}:

buildPythonPackage {
  pname = "pybind11-protobuf";
  version = "0-unstable-2025-10-29";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11_protobuf";
    rev = "4825dca68c8de73f5655fc50ce79c49c4d814652";
    hash = "sha256-SeIUyWLeThfBX3SljLdG7CbENdbuJG+X0+h/gn/ATWE=";
  };

  patches = [
    # Rebase of the OpenSUSE patch: https://build.opensuse.org/projects/openSUSE:Factory/packages/pybind11_protobuf/files/0006-Add-install-target-for-CMake-builds.patch?expand=1
    # on top of: https://github.com/pybind/pybind11_protobuf/pull/188/commits/5f0ac3d8c10cbb8b3b81063467c71085cd39624f
    ./add-install-target-for-cmake-builds.patch
  ];

  postPatch = ''
    substituteInPlace cmake/dependencies/CMakeLists.txt \
      --replace-fail 'find_package(protobuf 5.29.2 REQUIRED)' 'find_package(protobuf REQUIRED)'
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    abseil-cpp_202505
    protobuf
    pybind11
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_ABSEIL" true)
    (lib.cmakeBool "USE_SYSTEM_PROTOBUF" true)
    (lib.cmakeBool "USE_SYSTEM_PYBIND" true)

    # The find_package calls are local to the dependencies subdirectory
    (lib.cmakeBool "CMAKE_FIND_PACKAGE_TARGETS_GLOBAL" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Without it, Cmake prefers using Find-module which is mysteriously broken
    # But the generated Config works
    (lib.cmakeBool "CMAKE_FIND_PACKAGE_PREFER_CONFIG" true)
  ];

  meta = {
    description = "Pybind11 bindings for Google's Protocol Buffers";
    homepage = "https://github.com/pybind/pybind11_protobuf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
