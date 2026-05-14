{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  pkg-config,
  popt,
  mandoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "efivar";
  version = "39";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "efivar";
    rev = finalAttrs.version;
    hash = "sha256-s/1k5a3n33iLmSpKQT5u08xoj8ypjf2Vzln88OBrqf0=";
  };

  nativeBuildInputs = [
    pkg-config
    mandoc
  ];
  buildInputs = [ popt ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  makeFlags = [
    "prefix=$(out)"
    "libdir=$(out)/lib"
    "bindir=$(bin)/bin"
    "mandir=$(man)/share/man"
    "includedir=$(dev)/include"
    "PCDIR=$(dev)/lib/pkgconfig"
  ];

  meta = {
    description = "Tools and library to manipulate EFI variables";
    homepage = "https://github.com/rhboot/efivar";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21Only;
    # See https://github.com/NixOS/nixpkgs/issues/388309
    broken = stdenv.hostPlatform.is32bit;
  };
})
