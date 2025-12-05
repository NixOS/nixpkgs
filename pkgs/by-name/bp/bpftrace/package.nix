{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  llvmPackages,
  elfutils,
  bcc,
  libbpf,
  libbfd,
  libopcodes,
  glibc,
  cereal,
  asciidoctor,
  cmake,
  pkg-config,
  flex,
  bison,
  util-linux,
  xxd,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "bpftrace";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "bpftrace";
    repo = "bpftrace";
    rev = "v${version}";
    hash = "sha256-Wt1MXKOg48477HMszq1GAjs+ZELbfAfp+P2AYa+dg+Q=";
  };

  patches = [
    (fetchpatch {
      name = "attach_tracepoint_with_enums.patch";
      url = "https://github.com/bpftrace/bpftrace/pull/4714.patch";
      includes = [ "src/ast/passes/clang_parser.cpp" ];
      hash = "sha256-xk+/eBNJJJSUqNTs0HFr0BAaqRB5B7CNWRSmnoBMTs0=";
    })
    (fetchpatch {
      name = "increase-RLIMIT_NOFILE-if-needed.patch";
      url = "https://github.com/bpftrace/bpftrace/pull/4716.patch";
      includes = [
        "src/bpftrace.cpp"
        "src/main.cpp"
        "src/required_resources.h"
      ];
      hash = "sha256-kRFyfuLf2CUR5QNJljLFNwmAzAoa8I3DNIW4SWwSUd0=";
    })
  ];

  buildInputs = with llvmPackages; [
    llvm
    libclang
    elfutils
    bcc
    libbpf
    libbfd
    libopcodes
    cereal
    asciidoctor
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    flex
    bison
    llvmPackages.llvm.dev
    util-linux
    xxd
  ];

  cmakeFlags = [
    "-DLIBBCC_INCLUDE_DIRS=${bcc}/include"
    "-DUSE_SYSTEM_LIBBPF=ON"
    "-DSYSTEM_INCLUDE_PATHS=${glibc.dev}/include"
  ];

  # Pull BPF scripts into $PATH (next to their bcc program equivalents), but do
  # not move them to keep `${pkgs.bpftrace}/share/bpftrace/tools/...` working.
  postInstall = ''
    ln -sr $out/share/bpftrace/tools/*.bt $out/bin/
    # do not use /usr/bin/env for shipped tools
    # If someone can get patchShebangs to work here please fix.
    sed -i -e "1s:#!/usr/bin/env bpftrace:#!$out/bin/bpftrace:" $out/share/bpftrace/tools/*.bt
  '';

  outputs = [
    "out"
    "man"
  ];

  passthru.tests = {
    inherit (nixosTests) bpf;
  };

  meta = {
    description = "High-level tracing language for Linux eBPF";
    homepage = "https://github.com/bpftrace/bpftrace";
    changelog = "https://github.com/bpftrace/bpftrace/releases/tag/v${version}";
    mainProgram = "bpftrace";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      rvl
      thoughtpolice
      martinetd
      mfrw
      illustris
    ];
    platforms = lib.platforms.linux;
  };
}
