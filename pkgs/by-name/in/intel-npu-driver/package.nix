{
  lib,
  stdenv,
  udev,
  openssl,
  boost,
  cmake,
  git,
  fetchFromGitHub,
  standalone ? true,
  ...
}:

let
  version = "1.13.0";
  baseDrv = {
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
    ];

    nativeBuildInputs = [
      cmake
      git
    ];
  };

  mkInstallPhase = lib.concatMapStringsSep "\n" (
    component: "cmake --install . --component ${component} --prefix $out"
  );
in
stdenv.mkDerivation {
  inherit version;
  inherit (baseDrv) src buildInputs nativeBuildInputs;
  pname = "intel-npu-driver";

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

  passthru = {
    inherit standalone;

    level-zero = stdenv.mkDerivation {
      inherit (baseDrv) src buildInputs nativeBuildInputs;
      pname = "intel-npu-level-zero";
      version = "${version}-1.18.5";
      sourceRoot = "${baseDrv.src.name}/third_party/level-zero";

      installPhase = mkInstallPhase [ "level-zero" ];

      meta = {
        homepage = "https://github.com/oneapi-src/level-zero";
        description = "oneAPI Level Zero Specification Headers and Loader";
        platforms = [ "x86_64-linux" ];
        license = lib.licenses.mit;
      };
    };
  };
}
