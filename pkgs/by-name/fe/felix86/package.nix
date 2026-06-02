{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  libGL,
  libx11,
  vulkan-headers,
  vulkan-loader,

  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "felix86";
  version = "26.04";

  src = fetchFromGitHub {
    owner = "OFFTKP";
    repo = "felix86";
    tag = finalAttrs.version;
    hash = "sha256-onhPibvO74yo95zop7EhG+EILn4M70X9ivhS9I+fIBY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    vulkan-headers
  ];

  buildInputs = [
    libGL
    libx11
    vulkan-loader
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 felix86 $out/bin/felix86

    runHook postInstall
  '';

  cmakeFlags = [
    (lib.cmakeBool "ZYDIS_BUILD_DOXYGEN" false)
    (lib.cmakeBool "BUILD_TESTS" true)
  ];

  passthru.tests = callPackage ./test.nix { };

  meta = {
    description = "x86 and x86-64 userspace emulator for RISC-V Linux";
    homepage = "https://github.com/OFFTKP/felix86";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "felix86";
    platforms = [ "riscv64-linux" ];
  };
})
