{
  lib,
  stdenv,
  which,
  flex,
  bison,
  linuxHeaders ? stdenv.cc.libc.linuxHeaders,
  buildPackages,
  zstd,

  # apparmor deps
  libapparmor,
  apparmor-bin-utils,
  runtimeShellPackage,

  # testing
  perl,
  python3,
  bashInteractive,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "apparmor-parser";
  inherit (libapparmor) version src;

  postPatch = ''
    patchShebangs .

    substituteInPlace init/rc.apparmor.functions \
      --replace-fail "/sbin/apparmor_parser" "$out/bin/apparmor_parser" \
      --replace-fail "/usr/sbin/aa-status" "${lib.getExe' apparmor-bin-utils "aa-status"}"
    sed -i init/rc.apparmor.functions -e '2i . ${./fix-rc.apparmor.functions.sh}'

    cd parser

    substituteInPlace Makefile \
      --replace-fail "/usr/include/linux/capability.h" "${linuxHeaders}/include/linux/capability.h"

    # strict format check causes yacc auto-generated code to fail.
    # This is known, see https://gitlab.com/apparmor/apparmor/-/merge_requests/2039
    # removing the compile-time check here downgrades the issue and allows compilation to succeed
    substituteInPlace parser.h \
      --replace-fail 'extern void yyerror(const char *msg, ...) __attribute__((noreturn, format(printf, 1, 2)));' \
        'extern void yyerror(const char *msg, ...);'
  '';

  nativeBuildInputs = [
    bison
    flex
    which
  ];

  buildInputs = [
    libapparmor
    zstd
    runtimeShellPackage
  ];

  makeFlags = [
    "LANGS="
    "USE_SYSTEM=1"
    "INCLUDEDIR=${libapparmor}/include"
    "AR=${stdenv.cc.bintools.targetPrefix}ar"
    "POD2MAN=${lib.getExe' buildPackages.perl "pod2man"}"
    "POD2HTML=${lib.getExe' buildPackages.perl "pod2html"}"
    "MANDIR=share/man"
  ]
  ++ lib.optional finalAttrs.doCheck "PROVE=${lib.getExe' perl "prove"}";

  installFlags = [
    "DESTDIR=$(out)"
    "DISTRO=unknown"
  ];

  preCheck = "pushd ./tst";

  checkTarget = "tests";

  postCheck = "popd";

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  nativeCheckInputs = [
    bashInteractive
    perl
    python3
  ];

  strictDeps = true;

  meta = libapparmor.meta // {
    description = "Mandatory access control system - core library";
    mainProgram = "apparmor_parser";
  };
})
