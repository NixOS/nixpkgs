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
  ...
}:

stdenv.mkDerivation rec {
  pname = "intel-npu-driver";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-npu-driver";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-+WPJrxwUT0UwU8VpJ4Wnmu/hLkdCDwiidGQwjl1Nvxk=";
  };

  buildInputs = [
    udev
    openssl
    boost
    level-zero
  ];

  nativeBuildInputs = [
    cmake
    git
  ];

  outputs = [
    "out"
    "validation"
  ];

  postPatch = ''
    for test in kmd-test umd-test; do
      substituteInPlace validation/$test/CMakeLists.txt --replace \
        "COMPONENT validation-npu" \
        "DESTINATION $validation/bin COMPONENT validation-npu"
    done
  '';

  installPhase = ''
    cmake --install . --component level-zero-npu
    cmake --install . --component validation-npu
  '';

  meta = {
    homepage = "https://github.com/intel/linux-npu-driver";
    description = "Intel NPU (Neural Processing Unit) Standalone Driver";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pseudocc ];
  };
}
