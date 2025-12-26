{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  fetchpatch,
  argparse,
  mosquitto,
  cmake,
  autoconf,
  automake,
  libtool,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "ebusd";
  version = "25.1";

  src = fetchFromGitHub {
    owner = "john30";
    repo = "ebusd";
    rev = version;
    sha256 = "sha256-rj0Wkfk3Tpm58fbCUkgCdHt5MvW+tGgDyUd5COXfBc0=";
  };

  nativeBuildInputs = [
    cmake
    autoconf
    automake
    libtool
    pkg-config
  ];

  buildInputs = [
    argparse
    mosquitto
    openssl
  ];

  patches = [
    ./patches/ebusd-cmake.patch
  ];

  preInstall = ''
    mkdir -p $out/usr/bin
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
    "-DCMAKE_INSTALL_BINDIR=${placeholder "out"}/bin"
    "-DCMAKE_INSTALL_LOCALSTATEDIR=${placeholder "TMPDIR"}"
  ];

  postInstall = ''
    rmdir $out/usr/bin
    rmdir $out/usr
  '';

  meta = {
    description = "ebusd";
    homepage = "https://github.com/john30/ebusd";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nathan-gs ];
    platforms = lib.platforms.linux;
  };
}
