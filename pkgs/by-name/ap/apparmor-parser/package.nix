{
  lib,
  stdenv,
  which,
  flex,
  bison,
  linuxHeaders ? stdenv.cc.libc.linuxHeaders,
  buildPackages,

  # apparmor deps
  libapparmor,

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
    cd parser

    substituteInPlace Makefile \
      --replace-fail "/usr/include/linux/capability.h" "${linuxHeaders}/include/linux/capability.h"
    substituteInPlace rc.apparmor.functions \
      --replace-fail "/sbin/apparmor_parser" "$out/bin/apparmor_parser" # FIXME
    substituteInPlace rc.apparmor.functions \
      --replace-fail "/usr/sbin/aa-status" '$(which aa-status)'
    sed -i rc.apparmor.functions -e '2i . ${./fix-rc.apparmor.functions.sh}'
  '';

  nativeBuildInputs = [
    bison
    flex
    which
  ];

  buildInputs = [ libapparmor ];

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

  checkFlags = lib.optionals stdenv.hostPlatform.isMusl [
    # equality tests are broken on musl due to different priority values
    # https://gitlab.com/apparmor/apparmor/-/issues/513
    "-o equality"
  ];

  postCheck = "popd";

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkInputs = [
    bashInteractive
    perl
    python3
  ];

  meta = libapparmor.meta // {
    description = "Mandatory access control system - core library";
    mainProgram = "apparmor_parser";
  };
})
