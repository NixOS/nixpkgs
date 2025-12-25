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
  version = "0.4-2";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "bpftune";
    rev = "0.4-2";
    hash = "sha256-clfR2nZKB9ztfUEw+znr9/Rdefv4K+mTeRCSBLIBmVY=";
  };

  # Only run this patch if /lib/modules exists
  # because older versions hardcoded that path
  # but in 0.4-2 the code no longer uses it
  postPatch = ''
    substituteInPlace src/Makefile \
      --replace-fail /sbin /bin \
      --replace-fail ldconfig true
    substituteInPlace src/bpftune.service \
      --replace-fail /usr/sbin/bpftune "$out/bin/bpftune"

    if grep -q "/lib/modules" src/libbpftune.c; then
      substituteInPlace src/libbpftune.c \
        --replace-fail /lib/modules /run/booted-system/kernel-modules/lib/modules
    fi
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

  meta = {
    description = "BPF-based auto-tuning of Linux system parameters";
    mainProgram = "bpftune";
    homepage = "https://github.com/oracle-samples/bpftune";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
