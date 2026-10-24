{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  bpftools,
  libbpf,
  elfutils,
  zlib,
  zstd,
  linuxHeaders,
  llvmPackages_18,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aegisbpf";
  version = "0.9.0-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "ErenAri";
    repo = "Aegis-BPF";
    rev = "d0fa0012faef63a885bd6316630d5896bd56a4b4";
    hash = "sha256-DwhxjcDM6eZ2Dzi6uGigLUSEfKYjRehLfrW5jVqZiMs=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    # Unwrapped LLVM-18 clang builds the BPF object with exactly `-target bpf`:
    # the stdenv cc-wrapper injects hardening flags (e.g. -fzero-call-used-regs)
    # the bpf target rejects, and newer LLVM regresses BPF stack usage past the
    # 512-byte verifier limit. LLVM 18 matches upstream's tested clang matrix.
    llvmPackages_18.clang-unwrapped
    bpftools
  ];

  buildInputs = [
    libbpf
    elfutils
    zlib
    zstd # elfutils' libelf.pc requires libzstd
    linuxHeaders # asm-generic/* UAPI headers for the BPF object
  ];

  # Unwrapped clang has no default system-header search path; hand it the kernel
  # UAPI headers. The userspace C++ build uses the normal stdenv cc.
  env.CPATH = "${linuxHeaders}/include";

  cmakeFlags = [
    # Pre-generated CO-RE header (upstream ships one) => hermetic BPF build with
    # no /sys/kernel/btf dependency.
    (lib.cmakeFeature "VMLINUX_H" "${finalAttrs.src}/packaging/nix/vmlinux.x86_64.h")
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "ENABLE_RUST_PARSER_LINK" false)
    (lib.cmakeBool "STATIC_LIBBPF" false)
  ];

  # Upstream installs two system-config files to absolute /etc paths; redirect
  # them under $out for a hermetic install.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'DESTINATION /etc/default' 'DESTINATION ${placeholder "out"}/etc/default' \
      --replace-fail 'DESTINATION /etc/aegisbpf' 'DESTINATION ${placeholder "out"}/etc/aegisbpf'
  '';

  meta = {
    description = "BPF-LSM runtime security agent with race-free in-kernel enforcement";
    homepage = "https://github.com/ErenAri/Aegis-BPF";
    changelog = "https://github.com/ErenAri/Aegis-BPF/blob/${finalAttrs.src.rev}/docs/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erenari ];
    mainProgram = "aegisbpf";
    platforms = [ "x86_64-linux" ];
  };
})
