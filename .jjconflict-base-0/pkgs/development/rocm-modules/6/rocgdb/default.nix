{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, pkg-config
, texinfo
, bison
, flex
, glibc
, zlib
, gmp
, mpfr
, ncurses
, expat
, rocdbgapi
, python3
, babeltrace
, sourceHighlight
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocgdb";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCgdb";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-XeX/k8gfo9HgcUSIjs35C7IqCmFhvBOqQJSOoPF6HK4=";
  };

  nativeBuildInputs = [
    pkg-config
    texinfo # For makeinfo
    bison
    flex
  ];

  buildInputs = [
    zlib
    gmp
    mpfr
    ncurses
    expat
    rocdbgapi
    python3
    babeltrace
    sourceHighlight
  ];

  configureFlags = [
    # Ensure we build the amdgpu traget
    "--enable-targets=${stdenv.targetPlatform.config},amdgcn-amd-amdhsa"
    "--with-amd-dbgapi=yes"

    "--with-iconv-path=${glibc.bin}"
    "--enable-tui"
    "--with-babeltrace"
    "--with-python=python3"
    "--with-system-zlib"
    "--enable-64-bit-bfd"
    "--with-gmp=${gmp.dev}"
    "--with-mpfr=${mpfr.dev}"
    "--with-expat"
    "--with-libexpat-prefix=${expat.dev}"

    # So the installed binary is called "rocgdb" instead on plain "gdb"
    "--program-prefix=roc"

    # Disable building many components not used or incompatible with the amdgcn target
    "--disable-sim"
    "--disable-gdbserver"
    "--disable-ld"
    "--disable-gas"
    "--disable-gdbserver"
    "--disable-sim"
    "--disable-gdbtk"
    "--disable-gprofng"
    "--disable-shared"
  ];

  # The source directory for ROCgdb (based on upstream GDB) contains multiple project
  # of GNU’s toolchain (binutils and onther), we only need to install the GDB part.
  installPhase = ''
    make install-gdb
  '';

  # `-Wno-format-nonliteral` doesn't work
  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm source-level debugger for Linux, based on GDB";
    homepage = "https://github.com/ROCm/ROCgdb";
    license = licenses.gpl3Plus;
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versionAtLeast finalAttrs.version "7.0.0";
  };
})
