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

let
  version = "1.13.0";
  mkInstallPhase = lib.concatMapStringsSep "\n" (
    component: "cmake --install . --component ${component} --prefix $out"
  );
in
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

  installPhase = mkInstallPhase [
    "level-zero-npu"
    "validation-npu"
  ];

  meta = {
    homepage = "https://github.com/intel/linux-npu-driver";
    description = "Intel NPU (Neural Processing Unit) Standalone Driver";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    mainProgram = "npu-umd-test";
    maintainers = with lib.maintainers; [ pseudocc ];
  };
}
