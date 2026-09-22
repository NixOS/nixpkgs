{
  lib,
  stdenv,
  fetchurl,
  perl,
  bashNonInteractive,
  libunwind,
  buildPackages,
  gitUpdater,
  elfutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "strace";
  version = "7.2";

  src = fetchurl {
    url = "https://strace.io/files/${finalAttrs.version}/strace-${finalAttrs.version}.tar.xz";
    hash = "sha256-S95iRpJokNzugk9uasQqBnUvR9d+UJfYbjwNbUtwn+U=";
  };

  separateDebugInfo = true;

  outputs = [
    "out"
    "man"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ perl ];

  buildInputs = [
    bashNonInteractive # for strace-log-merge shebang
    # libunwind for -k.
    # On RISC-V platforms, LLVM's libunwind implementation is unsupported by strace.
    # The build will silently fall back and -k will not work on RISC-V.
    libunwind
  ]
  # -kk
  ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform elfutils) elfutils;

  enableParallelBuilding = true;
  strictDeps = true;

  configureFlags = [
    "--enable-mpers=check"
  ]
  ++ lib.optional stdenv.cc.isClang "CFLAGS=-Wno-unused-function";

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://github.com/strace/strace.git";
    rev-prefix = "v";
  };

  __structuredAttrs = true;

  meta = {
    homepage = "https://strace.io/";
    description = "System call tracer for Linux";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ]; # gpl2Plus is for the test suite
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      globin
      ma27
      qyliss
    ];
    mainProgram = "strace";
  };
})
