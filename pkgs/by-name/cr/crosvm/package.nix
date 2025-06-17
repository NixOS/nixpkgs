{
  lib,
  rustPlatform,
  fetchgit,
  pkg-config,
  protobuf,
  python3,
  wayland-scanner,
  libcap,
  libdrm,
  libepoxy,
  minijail,
  virglrenderer,
  wayland,
  wayland-protocols,
  writeShellScript,
  unstableGitUpdater,
  nix-update,
  pkgsCross,
}:

rustPlatform.buildRustPackage {
  pname = "crosvm";
  version = "0-unstable-2025-06-06";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "7083e31d219cdcd57866c70144e1b39ddc008f0f";
    hash = "sha256-oZR4UcN8lDoqNoUFGLbIDDRO55noDX0xMWa8W0DbVl4=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  useFetchCargoVendor = true;
  cargoHash = "sha256-3NcQQZCsR3ekPBbe/ai8ke3MxBy0ONg1TJO9qLSH7jM=";

  nativeBuildInputs = [
    pkg-config
    protobuf
    python3
    rustPlatform.bindgenHook
    wayland-scanner
  ];

  buildInputs = [
    libcap
    libdrm
    libepoxy
    minijail
    virglrenderer
    wayland
    wayland-protocols
  ];

  preConfigure = ''
    patchShebangs third_party/minijail/tools/*.py
  '';

  CROSVM_USE_SYSTEM_MINIGBM = true;
  CROSVM_USE_SYSTEM_VIRGLRENDERER = true;

  buildFeatures = [ "virgl_renderer" ];

  passthru = {
    updateScript = writeShellScript "update-crosvm.sh" ''
      set -ue
      ${lib.escapeShellArgs (unstableGitUpdater {
        url = "https://chromium.googlesource.com/crosvm/crosvm.git";
        hardcodeZeroVersion = true;
      })}
      exec ${lib.getExe nix-update} --version=skip
    '';

    tests = {
      musl = pkgsCross.musl64.crosvm;
    };
  };

  meta = with lib; {
    description = "Secure virtual machine monitor for KVM";
    homepage = "https://crosvm.dev/";
    mainProgram = "crosvm";
    maintainers = with maintainers; [ qyliss ];
    license = licenses.bsd3;
    platforms = [
      "aarch64-linux"
      "riscv64-linux"
      "x86_64-linux"
    ];
  };
}
