{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  cups,
  libcupsfilters,
  libppd,
  pappl-retrofit,
  pkg-config,
  pappl,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "ps-printer-app";
  version = "0-unstable-2022-12-08";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "ps-printer-app";
    rev = "4a54b0fca81209820a2e6cd9de21d36d9af5b8d9";
    hash = "sha256-WYie9oXWWJJnV2hgG5+76iWYOfDnIRjYE6uYdRQMGYg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    cups
    pappl
    pappl-retrofit
    libppd
    libcupsfilters
    systemd
  ];

  installFlags = [
    "prefix=${placeholder "out"}"
    "localstatedir=state"
    "unitdir=${placeholder "out"}/lib/systemd/system"
  ];

  meta = with lib; {
    description = "PostScript Printer Application";
    homepage = "https://github.com/OpenPrinting/ps-printer-app";
    license = licenses.asl20;
    maintainers = with maintainers; [ tmarkus ];
    platforms = platforms.unix;
  };
}
