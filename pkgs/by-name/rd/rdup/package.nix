{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  glib,
  pcre2,
  coreutils,
}:

stdenv.mkDerivation {
  pname = "rdup";
  version = "1.1.16-unstable-2024-03-05";

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "miekg";
    repo = "rdup";
    rev = "fa1c753a107c12b3797204c41779ce2c8d5da45a";
    hash = "sha256-k+386SrXE0IULP02/aOa5E/F/HWhnD/ttGzFStric5M=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    glib
  ];

  buildInputs = [
    glib
    pcre2
  ];

  installFlags = [ "INSTALL=${coreutils}/bin/install" ];

  meta = {
    description = "Only backup program that doesn't make backups";
    homepage = "https://github.com/miekg/rdup";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
