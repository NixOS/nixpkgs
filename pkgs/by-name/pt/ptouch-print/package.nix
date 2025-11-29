{
  argp-standalone,
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
  version = "1.7";

  src = fetchgit {
    url = "https://git.familie-radermacher.ch/linux/ptouch-print.git";
    rev = "v1.7";
    hash = "sha256-OdWdDjgA0Jltho9IB9btZW3UsU+EDm21iltQ1McgiqU=";
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
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isGnu) [
    argp-standalone
  ];

  patches = [
    ./argp.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv ptouch-print $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line tool to print labels on Brother P-Touch printers on Linux";
    homepage = "https://dominic.familie-radermacher.ch/projekte/ptouch-print/";
    license = licenses.gpl3Plus;
    mainProgram = "ptouch-print";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.unix;
  };
}
