{
  lib,
  stdenv,
  fetchFromGitHub,
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
  fetchpatch,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "bpftrace";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "bpftrace";
    repo = "bpftrace";
    rev = "v${version}";
    hash = "sha256-cmKm2g1lzl625t4z7ZM04QgqDubBsCMqtibXmg+3y9w=";
  };

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
  ];

  cmakeFlags = [
    "-DLIBBCC_INCLUDE_DIRS=${bcc}/include"
    "-DINSTALL_TOOL_DOCS=OFF"
    "-DSYSTEM_INCLUDE_PATHS=${glibc.dev}/include"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "set(MAX_LLVM_MAJOR 18)" "set(MAX_LLVM_MAJOR 19)"
  '';

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
    bpf = nixosTests.bpf;
  };

  meta = with lib; {
    description = "High-level tracing language for Linux eBPF";
    homepage = "https://github.com/bpftrace/bpftrace";
    changelog = "https://github.com/bpftrace/bpftrace/releases/tag/v${version}";
    mainProgram = "bpftrace";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rvl
      thoughtpolice
      martinetd
      mfrw
      illustris
    ];
    platforms = platforms.linux;
  };
}
