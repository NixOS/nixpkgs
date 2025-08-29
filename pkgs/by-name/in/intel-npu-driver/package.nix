{
  lib,
  stdenv,
  udev,
  openssl,
  boost,
  cmake,
  git,
  level-zero,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "intel-npu-driver";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-npu-driver";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-GxmAmbf28hn/ragkTkFBYbM6Z+uFR6X4foMOyE8UVAc=";
  };

  buildInputs = [
    udev
    openssl
    boost
    level-zero
  ];

  nativeBuildInputs = [
    cmake
  ];

  outputs = [
    "out"
    "validation"
    "firmware"
  ];

  postPatch = ''
    rm -rf third_party/level-zero
    rm third_party/cmake/level-zero.cmake
    rm third_party/cmake/FindLevelZero.cmake
    substituteInPlace third_party/CMakeLists.txt --replace-fail \
      "include(cmake/level-zero.cmake)" \
      ""
    substituteInPlace third_party/level-zero-npu-extensions/ze_graph_ext.h --replace-fail \
    "#include \"ze_api.h\"" \
    "#include <level_zero/ze_api.h>"

    substituteInPlace validation/{kmd-test,umd-test}/CMakeLists.txt --replace-fail \
      "COMPONENT validation-npu" \
      "DESTINATION $validation/bin COMPONENT validation-npu"

    substituteInPlace firmware/CMakeLists.txt --replace-fail \
      "DESTINATION /lib/firmware/updates/intel/vpu/" \
      "DESTINATION $firmware/lib/firmware/intel/vpu/"
  '';

  installPhase = ''
    cmake --install . --component level-zero-npu
    cmake --install . --component validation-npu
    cmake --install . --component fw-npu
  '';

  meta = {
    homepage = "https://github.com/intel/linux-npu-driver";
    description = "Intel NPU (Neural Processing Unit) Standalone Driver";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pseudocc ];
  };
}
