{
  lib,
  makeWrapper,
  gawk,
  perl,
  bash,
  stdenv,
  which,
  linuxHeaders ? stdenv.cc.libc.linuxHeaders,
  python3Packages,
  bashNonInteractive,
  buildPackages,

  # apparmor deps
  apparmor-parser,
  apparmor-teardown,
}:
let
  inherit (python3Packages) libapparmor;
in
python3Packages.buildPythonApplication {
  pname = "apparmor-utils";
  inherit (libapparmor) version src;

  postPatch = ''
    patchShebangs .
    cd utils

    substituteInPlace aa-remove-unknown \
      --replace-fail "/lib/apparmor/rc.apparmor.functions" "${apparmor-parser}/lib/apparmor/rc.apparmor.functions"
    substituteInPlace Makefile \
      --replace-fail "/usr/include/linux/capability.h" "${linuxHeaders}/include/linux/capability.h"
    sed -i -E 's/^(DESTDIR|BINDIR|PYPREFIX)=.*//g' Makefile
    sed -i aa-unconfined -e "/my_env\['PATH'\]/d"
  ''
  + (lib.optionalString stdenv.hostPlatform.isMusl ''
    sed -i Makefile -e "/\<vim\>/d"
  '');

  format = "other";
  strictDeps = true;

  doCheck = true;

  nativeBuildInputs = [
    makeWrapper
    which
    bashNonInteractive
    python3Packages.setuptools
  ];

  buildInputs = [
    bash
    perl
  ];

  pythonPath = [
    python3Packages.notify2
    python3Packages.psutil
    libapparmor
  ];

  makeFlags = [
    "LANGS="
    "POD2MAN=${lib.getExe' buildPackages.perl "pod2man"}"
    "POD2HTML=${lib.getExe' buildPackages.perl "pod2html"}"
    "MANDIR=share/man"
  ];

  installFlags = [
    "DESTDIR=$(out)"
    "BINDIR=$(out)/bin"
    "VIM_INSTALL_PATH=$(out)/share"
    "PYPREFIX="
  ];

  postInstall = ''
    wrapProgram $out/bin/aa-remove-unknown \
     --prefix PATH : ${lib.makeBinPath [ gawk ]}

    ln -s ${lib.getExe apparmor-teardown} $out/bin/aa-teardown
  '';

  meta = libapparmor.meta // {
    description = "Mandatory access control system - script user-land utilities";
  };
}
