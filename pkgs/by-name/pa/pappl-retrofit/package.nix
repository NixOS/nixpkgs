{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  cups,
  libcupsfilters,
  libppd,
  pappl,
}:

stdenv.mkDerivation rec {
  pname = "pappl-retrofit";
  version = "1.0b1";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "pappl-retrofit";
    rev = version;
    hash = "sha256-B39pSTn37iVu3BxlwN/6OmyV9Kvf2KeZnvGGrNeoq1M=";
  };

  patches = [
    ./cups-headers-include.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cups
    pappl
    libcupsfilters
    libppd
  ];

  postInstall = ''
    rm -rf $out/var
  '';

  meta = {
    description = "PPD/Classic CUPS driver retro-fit Printer Application Library";
    homepage = "https://github.com/OpenPrinting/pappl-retrofit";
    changelog = "https://github.com/OpenPrinting/pappl-retrofit/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tmarkus ];
    platforms = lib.platforms.unix;
  };
}
