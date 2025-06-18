{
  lib,
  stdenv,
  pkg-config,
  which,
  buildPackages,

  # apparmor deps
  libapparmor,

  # testing
  perl,
}:
stdenv.mkDerivation {
  pname = "apparmor-bin-utils";
  inherit (libapparmor)
    version
    src
    ;

  sourceRoot = "${libapparmor.src.name}/binutils";

  nativeBuildInputs = [
    pkg-config
    libapparmor
    which
  ];

  buildInputs = [
    libapparmor
  ];

  makeFlags = [
    "LANGS="
    "USE_SYSTEM=1"
    "POD2MAN=${lib.getExe' buildPackages.perl "pod2man"}"
    "POD2HTML=${lib.getExe' buildPackages.perl "pod2html"}"
    "MANDIR=share/man"
  ];

  doCheck = true;
  checkInputs = [ perl ];

  installFlags = [
    "DESTDIR=$(out)"
    "BINDIR=$(out)/bin"
    "SBINDIR=$(out)/bin"
  ];

  meta = libapparmor.meta // {
    description = "Mandatory access control system - binary user-land utilities";
  };
}
