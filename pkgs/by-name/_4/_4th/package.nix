{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "4th";
  version = "3.64.2";

  src = fetchurl {
    url = "https://sourceforge.net/projects/forth-4th/files/4th-${finalAttrs.version}/4th-${finalAttrs.version}-unix.tar.gz";
    hash = "sha256-ufQiuRDPmcYzFSQf16cuZSrOEbH3itq7yZYo87zPs1g=";
  };

  outputs = [
    "out"
    "man"
  ];

  dontConfigure = true;

  makeFlags = [
    "-C sources"
    "CC:=$(CC)"
    "AR:=$(AR)"
  ];

  preInstall = ''
    install -d ${placeholder "out"}/bin \
               ${placeholder "out"}/lib \
               ${placeholder "out"}/share/doc/4th \
               ${placeholder "man"}/share/man
  '';

  installFlags = [
    "BINARIES=${placeholder "out"}/bin"
    "LIBRARIES=${placeholder "out"}/lib"
    "DOCDIR=${placeholder "out"}/share/doc"
    "MANDIR=${placeholder "man"}/share/man"
  ];

  meta = {
    homepage = "https://thebeez.home.xs4all.nl/4tH/index.html";
    description = "Portable Forth compiler";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "4th";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.unix;
  };
})
# TODO: set Makefile according to platform
