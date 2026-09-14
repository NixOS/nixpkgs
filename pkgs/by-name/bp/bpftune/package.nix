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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bpftune";
  version = "ol10/bpftune-0.3-2";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "bpftune";
    tag = finalAttrs.version;
    hash = "sha256-SI3AV4By/bO0CYGg6oPVL87bxCj8EA+HDOeGPNtHsos=";
  };

  postPatch = ''
    # otherwise shrink rpath would drop $out/lib from rpath
    substituteInPlace src/Makefile \
      --replace-fail /sbin /bin \
      --replace-fail ldconfig true
    substituteInPlace src/bpftune.service \
      --replace-fail /usr/sbin/bpftune "$out/bin/bpftune"
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
    "BPFTUNE_VERSION=${finalAttrs.version}"
    "NL_INCLUDE=${lib.getDev libnl}/include/libnl3"
    "BPF_INCLUDE=${lib.getDev libbpf}/include"
  ];

  hardeningDisable = [
    "zerocallusedregs"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) bpftune;
    };
    updateScript = nix-update-script { };
  };

  enableParallelBuilding = true;

  meta = {
    description = "BPF-based auto-tuning of Linux system parameters";
    mainProgram = "bpftune";
    homepage = "https://github.com/oracle-samples/bpftune";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
