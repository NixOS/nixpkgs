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
  version = "0-unstable-2025-07-15";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "940eaae7246300bb01e1efb8c3d21ea93e0e63cd";
    hash = "sha256-UD2/mGZ9eBxYcf7QR+SATooxxdo9dG9U4DSSF5u8s4Y=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  useFetchCargoVendor = true;
  cargoHash = "sha256-k4lVgUNvQ8ySYs33nlyTcUgGxtXpiNEG/cFCAJNpJ+c=";

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
