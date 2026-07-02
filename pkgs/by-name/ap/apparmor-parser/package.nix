{
  lib,
  stdenv,
  which,
  flex,
  bison,
  linuxHeaders ? stdenv.cc.libc.linuxHeaders,
  buildPackages,
  zstd,
  fetchpatch,

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
  '';

  patches = [
    (fetchpatch {
      # https://gitlab.com/apparmor/apparmor/-/merge_requests/2133
      # Patches generated yacc parser code to compile with format-security
      url = "https://gitlab.com/apparmor/apparmor/-/commit/6bdec74d5e74660b97e00b4b8fafc014b05907b7.diff";
      hash = "sha256-7c5EFByrGIDj2lc31bRttyeybwndDm4iS4qdPMVaG/I=";
    })
  ];

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
