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
  version = "0-unstable-2026-02-13";

  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/platform/crosvm";
    rev = "4c80bf3523cf84114054209d88a7af3eefd8423f";
    hash = "sha256-JpOw2DJsSjgm14M3ZenlXhnnNeYZC+G8jw8e9oEsBnQ=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  cargoHash = "sha256-AW/Gzbksek0mZ3UCtK64SfaHdY7/FHVrQmQ9xyW8MZQ=";

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

  env = {
    CROSVM_USE_SYSTEM_MINIGBM = true;
    CROSVM_USE_SYSTEM_VIRGLRENDERER = true;
  };

  buildFeatures = [ "virgl_renderer" ];

  # Patch the bundled `.policy` source files in `jail/seccomp/<arch>/`
  # *before* crosvm's own build runs. crosvm's `jail/build.rs` invokes
  # `third_party/minijail/tools/compile_seccomp_policy.py` at compile
  # time and bakes the resulting `.bpf` programs into the binary
  # (since crosvm 107.1, fb60a5c9473b), so editing the source policies
  # at this point flows directly into the embedded filters that
  # crosvm jails its device proxies with at runtime.
  #
  # Two narrow widenings are required for any multi-process Rust device
  # proxy to function on Linux ≥ 6.13 with glibc ≥ 2.40, both in
  # `common_device.policy`:
  #
  #   - `prctl: arg0 == PR_SET_VMA` gains an `|| arg0 == PR_SET_NAME`
  #     alternation. Rust's `std::thread::Thread::new` calls
  #     `prctl(PR_SET_NAME, ...)` from the new thread before user code
  #     runs; without this, every device proxy that spawns a worker
  #     thread (serial, xhci, virtio-block, ...) dies with SIGSYS
  #     during `pthread_create`.
  #
  #   - `madvise: arg2 == <fixed MADV_* list>` gains an
  #     `|| arg2 == 102` alternation (`MADV_GUARD_INSTALL`). On kernel
  #     6.13+, glibc 2.40+ uses `MADV_GUARD_INSTALL` for stack guard
  #     pages, which isn't in the bundled list, and every Rust thread
  #     spawn dies the moment glibc decides to install guard pages.
  #     The constant is referenced numerically because
  #     `compile_seccomp_policy.py`'s constants table predates it.
  #     Keeping the rule a conditional alternation (rather than
  #     collapsing to `madvise: 1`) preserves the bundled `@include`
  #     contract — sub-policies like `jail_warden.policy` redefine
  #     `madvise` themselves, which the minijail parser only allows
  #     while the parent rule is conditional.
  postPatch = ''
    if [ ! -f jail/seccomp/x86_64/common_device.policy ]; then
      echo "no common_device.policy found under jail/seccomp/x86_64/" >&2
      exit 1
    fi
    for policy in jail/seccomp/*/common_device.policy; do
      sed -i \
        -e 's~^prctl: arg0 == PR_SET_VMA$~prctl: arg0 == PR_SET_VMA || arg0 == PR_SET_NAME~' \
        -e 's~^\(madvise: arg2 ==.*\)$~\1 || arg2 == 102~' \
        "$policy"
    done
  '';

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
