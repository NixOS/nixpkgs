{
  lib,
  stdenv,
  targetPackages,

  # Build time
  fetchurl,
  pkg-config,
  perl,
  texinfo,
  setupDebugInfoDirs,
  buildPackages,

  # Run time
  readline,
  expat,
  libipt,
  zlib,
  zstd,
  xz,
  dejagnu,
  sourceHighlight,
  libiconv,
  xxHash,

  withTui ? true,
  ncurses,
  withGmp ? true,
  gmp,
  withMpfr ? true,
  mpfr,
  withGuile ? false,
  guile,
  pythonSupport ? stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.hostPlatform.isCygwin,
  python3,
  enableDebuginfod ? lib.meta.availableOn stdenv.hostPlatform elfutils,
  elfutils,
  hostCpuOnly ? false,
  enableSim ? false,
  enableUbsan ? false,
  safePaths ? [
    # $debugdir:$datadir/auto-load are whitelisted by default by GDB
    "$debugdir"
    "$datadir/auto-load"
    # targetPackages so we get the right libc when cross-compiling and using buildPackages.gdb
    (lib.getLib targetPackages.stdenv.cc.cc)
  ],
  writeScript,
}:

let
  inherit (lib)
    optional
    optionals
    optionalString
    withFeature
    enableFeature
    withFeatureAs
    ;
  targetPrefix = optionalString (
    stdenv.targetPlatform != stdenv.hostPlatform
  ) "${stdenv.targetPlatform.config}-";
  pname = targetPrefix + "gdb" + optionalString hostCpuOnly "-host-cpu-only";
in

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "17.1";

  src = fetchurl {
    url = "mirror://gnu/gdb/gdb-${finalAttrs.version}.tar.xz";
    hash = "sha256-FJlvX3TJ9o9aVD/cRbyngAIH+R+SrupsLnkYIsfG2HY=";
  };

  postPatch =
    optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace gdb/darwin-nat.c \
        --replace-fail '#include "bfd/mach-o.h"' '#include "mach-o.h"'
    ''
    + optionalString stdenv.hostPlatform.isMusl ''
      substituteInPlace sim/erc32/erc32.c  --replace-fail sys/fcntl.h fcntl.h
      substituteInPlace sim/erc32/interf.c  --replace-fail sys/fcntl.h fcntl.h
      substituteInPlace sim/erc32/sis.c  --replace-fail sys/fcntl.h fcntl.h
      substituteInPlace sim/ppc/emul_unix.c --replace-fail sys/termios.h termios.h
    '';

  patches = [
    ./debug-info-from-env.patch
  ]
  ++ optionals stdenv.hostPlatform.isDarwin [
    ./darwin-target-match.patch
  ];

  nativeBuildInputs = [
    pkg-config
    texinfo
    perl
    setupDebugInfoDirs
  ];

  buildInputs = [
    ncurses
    readline
    expat
    libipt
    zlib
    zstd
    xz
    sourceHighlight
    xxHash
    dejagnu # for tests
  ]
  ++ optional withTui ncurses
  ++ optional withMpfr mpfr
  ++ optional withGmp gmp
  ++ optional pythonSupport python3
  ++ optional withGuile guile
  ++ optional enableDebuginfod (elfutils.override { enableDebuginfod = true; })
  ++ optional stdenv.hostPlatform.isDarwin libiconv;

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  enableParallelBuilding = true;

  # darwin build fails with format hardening since v7.12
  hardeningDisable = optionals stdenv.hostPlatform.isDarwin [ "format" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  # Workaround for Apple Silicon, configurePlatforms must be disabled
  configurePlatforms = optionals (!(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) [
    "build"
    "host"
    "target"
  ];

  preConfigure = ''
    # remove precompiled docs, required for man gdbinit to mention /etc/gdb/gdbinit
    rm gdb/doc/*.info*
    rm gdb/doc/*.5
    rm gdb/doc/*.1

    # fix doc build https://sourceware.org/bugzilla/show_bug.cgi?id=27808
    rm gdb/doc/GDBvn.texi

    # GDB have to be built out of tree.
    mkdir _build
    cd _build
  '';
  configureScript = "../configure";

  configureFlags = [
    # Set the program prefix to the current targetPrefix.
    # This ensures that the prefix always conforms to
    # nixpkgs' expectations instead of relying on the build
    # system which only receives `config` which is merely a
    # subset of the platform description.
    "--program-prefix=${targetPrefix}"

    (enableFeature true "werror")
    (enableFeature true "64-bit-bfd")
    (enableFeature false "install-libbfd")
    (enableFeature withTui "tui")
    (withFeature withTui "curses")
    (enableFeature false "shared")
    (enableFeature true "static")
    (withFeature true "system-readline")
    (withFeature true "system-zlib")
    (withFeature true "expat")
    (withFeatureAs true "libexpat-prefix" "${expat.dev}")
    (withFeatureAs withGmp "gmp" "${gmp.dev}")
    (withFeatureAs withMpfr "mpfr" "${mpfr.dev}")
    (withFeature pythonSupport "python")
    (withFeature withGuile "guile")
    (enableFeature enableSim "sim")
    (enableFeature enableUbsan "ubsan")
    (withFeatureAs true "system-gdbinit" "/etc/gdb/gdbinit")
    (withFeatureAs true "system-gdbinit-dir" "/etc/gdb/gdbinit.d")
    (withFeatureAs true "auto-load-safe-path" (builtins.concatStringsSep ":" safePaths))
    (withFeature enableDebuginfod "debuginfod")
    (enableFeature (!stdenv.hostPlatform.isMusl) "nls")
  ]
  ++ optional (!hostCpuOnly) "--enable-targets=all"
  ++ [
    (enableFeature (
      !stdenv.hostPlatform.isStatic && !stdenv.hostPlatform.isLoongArch64
    ) "inprocess-agent")
  ]
  # Workaround for Apple Silicon, "--target" must be "faked", see eg: https://github.com/Homebrew/homebrew-core/pull/209753
  ++ optional (
    stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64
  ) "--target=x86_64-apple-darwin";

  postInstall = ''
    # Remove Info files already provided by Binutils and other packages.
    rm -v $out/share/info/bfd.info
  '';

  passthru = {
    updateScript = writeScript "update-gdb" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of '<h3>GDB version 12.1</h3>'
      new_version="$(curl -s https://www.sourceware.org/gdb/ |
          pcregrep -o1 '<h3>GDB version ([0-9.]+)</h3>')"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = {
    description = "GNU Project debugger";
    mainProgram = "gdb";
    longDescription = ''
      GDB, the GNU Project debugger, allows you to see what is going
      on `inside' another program while it executes -- or what another
      program was doing at the moment it crashed.
    '';
    homepage = "https://www.gnu.org/software/gdb/";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ cygwin ++ freebsd ++ darwin;
    maintainers = with lib.maintainers; [
      pierron
      globin
    ];
  };
})
