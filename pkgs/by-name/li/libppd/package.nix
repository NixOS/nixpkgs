{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cups,
  libcupsfilters,
  ghostscript,
  pkg-config,
  poppler_utils,
  mupdf,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libppd";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "libppd";
    rev = version;
    hash = "sha256-Pg64zBHZ7vDxMRpJB+JPrj2DwoRPYKF35oE20ipgTjU=";
  };

  patches = lib.optionals (stdenv.hostPlatform.libc != "glibc") [
    # Fix missing includes on darwin
    ./libppd-libc-compat.patch
    ./libppd-zlib.patch
  ];

  configureFlags = [
    "--with-mutool-path=${lib.getBin mupdf}/bin/mutool"
    "--with-pdftops=pdftops"
    "--with-pdftops-path=${lib.getBin poppler_utils}/bin/pdftops"
    "--with-gs-path=${lib.getExe ghostscript}"
    "--with-pdftocairo-path=${lib.getBin poppler_utils}/bin/pdftocairo"
    "--with-ippfind-path=${lib.getBin cups}/bin/ippfind"
    "--disable-acroread"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cups
    ghostscript
    poppler_utils
    mupdf
    libcupsfilters
    zlib
  ];

  postInstall = ''
    rmdir $out/bin
  '';

  meta = {
    description = "Legacy support library for PPD files";
    homepage = "https://github.com/OpenPrinting/libppd";
    changelog = "https://github.com/OpenPrinting/libppd/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tmarkus ];
    platforms = lib.platforms.unix;
  };
}
