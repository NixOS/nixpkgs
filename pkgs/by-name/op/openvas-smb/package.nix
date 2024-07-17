{
  fetchFromGitHub,
  fetchurl,
  lib,
  stdenv,
  cmake,
  git,
  pkg-config,
  glib,
  gnutls,
  perl,
  heimdal,
  popt,
  libunistring,
}:
let
  heimdalConfigHeader = fetchurl {
    url = "https://raw.githubusercontent.com/heimdal/heimdal/d8c10e68a61f10c8fca62b227a0766d294bda4a0/include/heim_threads.h";
    sha256 = "08345hkb5jbdcgh2cx3d624w4c8wxmnnsjxlw46wsnm39k4l0ihw";
  };
in
stdenv.mkDerivation rec {
  pname = "openvas-smb";
  version = "22.5.6";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "openvas-smb";
    rev = "refs/tags/v${version}";
    hash = "sha256-wnlBOHYOTWNbwzoHCpsXbuhp0uH3wBH6+Oo4Y+zSsfg=";
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs = [
    glib
    gnutls
    perl
    heimdal
    popt
    libunistring
  ];

  # The pkg expects the heimdal headers to be in a "heimdal" folder, which is the case on
  # debian, but not on nix. Additionally some heimdal header names have the same names
  # as kerberos header names, so the old include path is removed.
  preConfigure = ''
    mkdir -p include

    # symlink to change include path for heimdal headers from "heim_etc.h" to "heimdal/heim_etc.h"
    ln -s ${heimdal.dev}/include include/heimdal
    remove="-isystem ${heimdal.dev}/include "
    NIX_CFLAGS_COMPILE=''${NIX_CFLAGS_COMPILE//"''$remove"/}
    NIX_CFLAGS_COMPILE+=" -isystem $(pwd)/include";

    # add default config header for heimdal
    cp ${heimdalConfigHeader} include/heim_threads.h
  '';

  meta = with lib; {
    description = "SMB module for Greenbone Community Edition";
    homepage = "https://github.com/greenbone/openvas-smb";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ mi-ael ];
    mainProgram = "wmic";
    platforms = platforms.unix;
  };
}
