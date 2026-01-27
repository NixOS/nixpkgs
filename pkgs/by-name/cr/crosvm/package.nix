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
  version = "0-unstable-2026-01-23";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "ef84b64479628b54829ba17516f36a0eef591364";
    hash = "sha256-n1rBSWy8MgcB9qt4KotGaU0Zy620gI11sDnWHKNEDxk=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  cargoHash = "sha256-M4V5NaTfqWLyB/8tiwzlua2bC+O8bZ07ppd196YYGDk=";

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

  meta = {
    description = "Secure virtual machine monitor for KVM";
    homepage = "https://crosvm.dev/";
    mainProgram = "crosvm";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.bsd3;
    platforms = [
      "aarch64-linux"
      "riscv64-linux"
      "x86_64-linux"
    ];
  };
}
