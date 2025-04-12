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
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "bpftrace";
    repo = "bpftrace";
    rev = "v${version}";
    hash = "sha256-/2m+5iFE7R+ZEc/VcgWAhkLD/jEK88roUUOUyYODi0U=";
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

  # tests aren't built, due to gtest shenanigans. see:
  #
  #     https://github.com/bpftrace/bpftrace/issues/161#issuecomment-453606728
  #     https://github.com/bpftrace/bpftrace/pull/363
  #
  cmakeFlags = [
    "-DBUILD_TESTING=FALSE"
    "-DLIBBCC_INCLUDE_DIRS=${bcc}/include"
    "-DINSTALL_TOOL_DOCS=OFF"
    "-DSYSTEM_INCLUDE_PATHS=${glibc.dev}/include"
  ];

  patches = [
    (fetchpatch {
      name = "runqlat-bt-no-includes.patch";
      url = "https://github.com/bpftrace/bpftrace/pull/3262.patch";
      hash = "sha256-9yqaZeG1Uf2cC9Aa40c2QUTQRl8n2NO1nq278hf9P4M=";
    })
    (fetchpatch {
      name = "kheaders-not-found-message-only-on-error.patch";
      url = "https://github.com/bpftrace/bpftrace/pull/3265.patch";
      hash = "sha256-8AICMzwq5Evy9+hmZhFjccw/HmgZ9t+YIoHApjLv6Uc=";
      excludes = [ "CHANGELOG.md" ];
    })
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
    ];
    platforms = platforms.linux;
  };
}
