{
  lib,
  stdenv,
  fetchpatch,
  linuxHeaders,
  buildPackages,
  libopcodes,
  libopcodes_2_38,
  libbfd,
  libbfd_2_38,
  elfutils,
  readline,
  zlib,
  python3,
  bison,
  flex,
}:

stdenv.mkDerivation rec {
  pname = "bpftools";

  inherit (linuxHeaders) version src;

  separateDebugInfo = true;

  patches = [
    # fix unknown type name '__vector128' on ppc64le
    ./include-asm-types-for-ppc64le.patch
    # fix build for riscv64
    (fetchpatch {
      # libbpf: Add missing per-arch include path
      # https://patchwork.kernel.org/project/linux-riscv/patch/20240927131355.350918-1-bjorn@kernel.org/
      url = "https://patchwork.kernel.org/project/linux-riscv/patch/20240927131355.350918-1-bjorn@kernel.org/raw/";
      hash = "sha256-edXY/ejHW5L7rGgY5B2GmVZxUgnLdBadNhBOSAgcL7M=";
    })
    (fetchpatch {
      # selftests: bpf: Add missing per-arch include path
      # https://patchwork.kernel.org/project/linux-riscv/patch/20240927131355.350918-2-bjorn@kernel.org/
      url = "https://patchwork.kernel.org/project/linux-riscv/patch/20240927131355.350918-2-bjorn@kernel.org/raw/";
      hash = "sha256-7yNWE/L/qd3vcLtJYoSyGxB3ytySlr20R0D3t5ni2Fc=";
    })
    (fetchpatch {
      # tools: Override makefile ARCH variable if defined, but empty
      # https://patchwork.kernel.org/project/linux-riscv/patch/20241127101748.165693-1-bjorn@kernel.org/
      url = "https://patchwork.kernel.org/project/linux-riscv/patch/20241127101748.165693-1-bjorn@kernel.org/raw/";
      hash = "sha256-y8N71Hm1XfX9g3S6PzW2m7Lxp6wQQMfQE9L0QNt8cYY=";
    })
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    python3
    bison
    flex
  ];
  buildInputs =
    (
      if (lib.versionAtLeast version "5.20") then
        [
          libopcodes
          libbfd
        ]
      else
        [
          libopcodes_2_38
          libbfd_2_38
        ]
    )
    ++ [
      elfutils
      zlib
      readline
    ];

  preConfigure = ''
    patchShebangs scripts/bpf_doc.py

    cd tools/bpf
    substituteInPlace ./bpftool/Makefile \
      --replace '/usr/local' "$out" \
      --replace '/usr'       "$out" \
      --replace '/sbin'      '/bin'
  '';

  buildFlags = [
    "bpftool"
    "bpf_asm"
    "bpf_dbg"
  ];

  # needed for cross to riscv64
  makeFlags = [ "ARCH=${stdenv.hostPlatform.linuxArch}" ];

  installPhase = ''
    make -C bpftool install
    install -Dm755 -t $out/bin bpf_asm
    install -Dm755 -t $out/bin bpf_dbg
  '';

  meta = with lib; {
    homepage = "https://github.com/libbpf/bpftool";
    description = "Debugging/program analysis tools for the eBPF subsystem";
    license = [
      licenses.gpl2Only
      licenses.bsd2
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
