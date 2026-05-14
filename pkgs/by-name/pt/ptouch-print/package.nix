{
  cmake,
  fetchgit,
  gd,
  gettext,
  git,
  lib,
  libjpeg,
  libpng,
  libusb1,
  pkg-config,
  stdenv,
  zlib,
}:

stdenv.mkDerivation {
  pname = "ptouch-print";
  version = "1.7-unstable-2026-01-23";

  src = fetchgit {
    url = "https://git.familie-radermacher.ch/linux/ptouch-print.git";
    rev = "3e026ef26b48dda338bb983132494935d6aeb626";
    hash = "sha256-LpBgZWpbOiEf+yA/fDNwsSPxkgMVLnOsrE65Q3lvhwg";
  };

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ];

  buildInputs = [
    gd
    gettext
    libjpeg
    libpng
    zlib
    libusb1
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv ptouch-print $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Command line tool to print labels on Brother P-Touch printers on Linux";
    homepage = "https://dominic.familie-radermacher.ch/projekte/ptouch-print/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ptouch-print";
    platforms = lib.platforms.unix;
  };
}
