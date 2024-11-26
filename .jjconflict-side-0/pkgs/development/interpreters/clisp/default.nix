# there are the following linking sets:
# - boot (not installed): without modules, only used when building clisp
# - base (default): contains readline and i18n, regexp and syscalls modules
#   by default
# - full: contains base plus modules in withModules
{
  lib,
  stdenv,
  fetchFromGitLab,
  autoconf269,
  automake,
  libtool,
  libsigsegv,
  gettext,
  ncurses,
  pcre,
  zlib,
  readline,
  libffi,
  libffcall,
  libX11,
  libXau,
  libXt,
  libXpm,
  libXext,
  xorgproto,
  coreutils,
  # build options
  threadSupport ? (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.isDarwin),
  x11Support ? (stdenv.hostPlatform.isx86 && !stdenv.hostPlatform.isDarwin),
  dllSupport ? true,
  withModules ?
    [
      "asdf"
      "pcre"
      "rawsock"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      "bindings/glibc"
      "zlib"
    ]
    ++ lib.optional x11Support "clx/new-clx",
}:

assert
  x11Support
  -> (
    libX11 != null
    && libXau != null
    && libXt != null
    && libXpm != null
    && xorgproto != null
    && libXext != null
  );

let
  ffcallAvailable = stdenv.hostPlatform.isLinux && (libffcall != null);
  # Some modules need autoreconf called in their directory.
  shouldReconfModule = name: name != "asdf";
in

stdenv.mkDerivation {
  version = "2.50pre20230112";
  pname = "clisp";

  src = fetchFromGitLab {
    owner = "gnu-clisp";
    repo = "clisp";
    rev = "bf72805c4dace982a6d3399ff4e7f7d5e77ab99a";
    hash = "sha256-sQoN2FUg9BPaCgvCF91lFsU/zLja1NrgWsEIr2cPiqo=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoconf269
    automake
    libtool
  ];
  buildInputs =
    [ libsigsegv ]
    ++ lib.optional (gettext != null) gettext
    ++ lib.optional (ncurses != null) ncurses
    ++ lib.optional (pcre != null) pcre
    ++ lib.optional (zlib != null) zlib
    ++ lib.optional (readline != null) readline
    ++ lib.optional (ffcallAvailable && (libffi != null)) libffi
    ++ lib.optional ffcallAvailable libffcall
    ++ lib.optionals x11Support [
      libX11
      libXau
      libXt
      libXpm
      xorgproto
      libXext
    ];

  patches = [
    ./gnulib_aarch64.patch
  ];

  # First, replace port 9090 (rather low, can be used)
  # with 64237 (much higher, IANA private area, not
  # anything rememberable).
  postPatch = ''
    sed -e 's@9090@64237@g' -i tests/socket.tst
    sed -i 's@/bin/pwd@${coreutils}&@' src/clisp-link.in
    sed -i 's@1\.16\.2@${automake.version}@' src/aclocal.m4
    find . -type f | xargs sed -e 's/-lICE/-lXau &/' -i
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin (
    ''
      (
        cd src
        autoreconf -f -i -I m4 -I glm4
      )
    ''
    + lib.concatMapStrings (x: ''
      (
        root="$PWD"
        cd modules/${x}
        autoreconf -f -i -I "$root/src" -I "$root/src/m4" -I "$root/src/glm4"
      )
    '') (builtins.filter shouldReconfModule withModules)
  );

  configureFlags =
    [ "builddir" ]
    ++ lib.optional (!dllSupport) "--without-dynamic-modules"
    ++ lib.optional (readline != null) "--with-readline"
    # --with-dynamic-ffi can only exist with --with-ffcall - foreign.d does not compile otherwise
    ++ lib.optional (ffcallAvailable && (libffi != null)) "--with-dynamic-ffi"
    ++ lib.optional ffcallAvailable "--with-ffcall"
    ++ lib.optional (!ffcallAvailable) "--without-ffcall"
    ++ builtins.map (x: " --with-module=" + x) withModules
    ++ lib.optional threadSupport "--with-threads=POSIX_THREADS";

  preBuild = ''
    sed -e '/avcall.h/a\#include "config.h"' -i src/foreign.d
    sed -i -re '/ cfree /d' -i modules/bindings/glibc/linux.lisp
    cd builddir
  '';

  doCheck = true;

  postInstall = lib.optionalString (withModules != [ ]) (
    ''./clisp-link add "$out"/lib/clisp*/base "$(dirname "$out"/lib/clisp*/base)"/full''
    + lib.concatMapStrings (x: " " + x) withModules
  );

  env.NIX_CFLAGS_COMPILE = "-O0 -falign-functions=${
    if stdenv.hostPlatform.is64bit then "8" else "4"
  }";

  meta = {
    description = "ANSI Common Lisp Implementation";
    homepage = "http://clisp.org";
    mainProgram = "clisp";
    maintainers = lib.teams.lisp.members;
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ darwin;
  };
}
