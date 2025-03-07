{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  bpftools,
  docutils,
  libbpf,
  libcap,
  libnl,
  nixosTests,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "bpftune";
  version = "0-unstable-2025-02-13";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "bpftune";
    rev = "2f73157b0e6f15034d898f3f92a376e89c3e3819";
    hash = "sha256-0hgTJkGEU1xw2aCvTbhMVOz6EKtICrBqVPwIh5vxCOI=";
  };

  postPatch = ''
    # otherwise shrink rpath would drop $out/lib from rpath
    substituteInPlace src/Makefile \
      --replace-fail /sbin    /bin \
      --replace-fail ldconfig true
    substituteInPlace src/bpftune.service \
      --replace-fail /usr/sbin/bpftune "$out/bin/bpftune"
    substituteInPlace src/libbpftune.c \
      --replace-fail /lib/modules /run/booted-system/kernel-modules/lib/modules
  '';

  nativeBuildInputs = [
    clang
    bpftools
    docutils # rst2man
  ];

  buildInputs = [
    libbpf
    libcap
    libnl
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "confprefix=${placeholder "out"}/etc"
    "libdir=lib"
    "BPFTUNE_VERSION=${version}"
    "NL_INCLUDE=${lib.getDev libnl}/include/libnl3"
    "BPF_INCLUDE=${lib.getDev libbpf}/include"
  ];

  hardeningDisable = [
    "stackprotector"
    "zerocallusedregs"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) bpftune;
    };
    updateScript = unstableGitUpdater { };
  };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "BPF-based auto-tuning of Linux system parameters";
    mainProgram = "bpftune";
    homepage = "https://github.com/oracle-samples/bpftune";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nickcao ];
  };
}
