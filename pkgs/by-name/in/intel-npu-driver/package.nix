{
  lib,
  stdenv,
  udev,
  openssl,
  boost,
  cmake,
  git,
  level-zero,
  pkg-config,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "intel-npu-driver";
  version = "1.35.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-npu-driver";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-n23yb6ZEJ7bfLactFixBQTcRlSIsVMOJ1QESoHLIhPg=";
  };

  buildInputs = [
    udev
    openssl
    boost
    level-zero
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=missing-field-initializers";

  outputs = [
    "out"
    "validation"
    "firmware"
  ];

  postPatch = ''
    rm third_party/cmake/level-zero.cmake

    substituteInPlace third_party/yaml-cpp/CMakeLists.txt --replace-fail \
      "cmake_minimum_required" \
      "# cmake_minimum_required"

    substituteInPlace third_party/CMakeLists.txt --replace-fail \
      "include(cmake/level-zero.cmake)" \
      "include(cmake/FindLevelZero.cmake)"

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
