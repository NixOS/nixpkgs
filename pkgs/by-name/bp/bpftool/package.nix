{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,

  libbpf,

  libcap,
  elfutils,
  openssl,
  zstd,

  withBfd ? false,
  libbfd,
  libopcodes,
  zlib,

  withLLVM ? true,
  llvmPackages,

  withDocumentation ? true,
  docutils,
}:

assert lib.assertMsg (withLLVM || withBfd) "bpftool: needs either withBfd or withLLVM";

stdenv.mkDerivation (finalAttrs: {
  pname = "bpftool";
  version = "7.8.0";

  src = fetchFromGitHub {
    owner = "libbpf";
    repo = "bpftool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YPS8JBOfEmbapp0jI+rY66dmEGlviEb6wfdiJV60G2g=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;
  enableParallelBuilding = true;

  nativeBuildInputs =
    lib.optionals withLLVM [
      (lib.getDev llvmPackages.libllvm)
      llvmPackages.clang-unwrapped
    ]
    ++ lib.optionals withDocumentation [
      docutils
    ];

  buildInputs = [
    libcap
    elfutils
    openssl
    zlib
    zstd
  ]
  ++ lib.optionals withLLVM [
    (lib.getLib llvmPackages.llvm)
  ]
  ++ lib.optionals withBfd [
    libbfd
    libopcodes
  ];

  postPatch = ''
    substituteInPlace ./src/Makefile \
      --replace-fail '/usr/local' "$out" \
      --replace-fail '/usr'       "$out" \
      --replace-fail '/sbin'      '/bin'

    rmdir libbpf
    ln -sf ${libbpf.src} libbpf
  '';

  preConfigure = ''
    cd src
  '';

  buildFlags = [
    "bpftool"
    "doc"
  ];

  # set version explicitly, otherwise bpftool will use libbpf's version
  env.BPFTOOL_VERSION = finalAttrs.version;

  installFlags = [
    "prefix=${placeholder "out"}"
    "bash_compdir=${placeholder "out"}/share/bash-completion/completions"
    "install"
    "doc-install"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    homepage = "https://github.com/libbpf/bpftool";
    description = "Debugging/program analysis tools for the eBPF subsystem";
    license =
      with lib.licenses;
      OR [
        gpl2Only
        bsd2
      ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
})
