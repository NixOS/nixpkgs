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
  version = "24.1";

  src = fetchFromGitHub {
    owner = "john30";
    repo = "ebusd";
    rev = version;
    sha256 = "sha256-+3QOB7/yCgR4j2UGfhWQ5s5sldoNfWSzX7qa//FHeJ4=";
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

  meta = with lib; {
    description = "ebusd";
    homepage = "https://github.com/john30/ebusd";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nathan-gs ];
    platforms = platforms.linux;
  };
}
