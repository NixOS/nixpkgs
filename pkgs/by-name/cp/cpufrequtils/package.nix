{
  lib,
  stdenv,
  fetchurl,
  libtool,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "cpufrequtils";
  version = "008";

  src = fetchurl {
    url = "http://ftp.be.debian.org/pub/linux/utils/kernel/cpufreq/cpufrequtils-${version}.tar.gz";
    hash = "sha256-AFOgcYPQaUg70GJhS8YcuAgMV32mHN9+ExsGThoa8Yg=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/bin/install install
  '';

  makeFlags = [
    "bindir=$(out)/bin"
    "sbindir=$(out)/sbin"
    "mandir=$(man)/man"
    "includedir=$(dev)/include"
    "libdir=$(lib)/lib"
    "localedir=$(out)/share/locale"
    "docdir=$(man)/share/doc/packages/cpufrequtils"
    "confdir=$(out)/etc/"
  ];

  buildInputs = [
    stdenv.cc.libc.linuxHeaders
    libtool
    gettext
  ];

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  meta = {
    description = "Tools to display or change the CPU governor settings";
    homepage = "http://ftp.be.debian.org/pub/linux/utils/kernel/cpufreq/cpufrequtils.html";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cpufreq-set";
  };
}
