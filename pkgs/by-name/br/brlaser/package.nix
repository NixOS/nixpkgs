{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  cups,
}:

stdenv.mkDerivation rec {
  pname = "brlaser";
  version = "6.2.7";

  src = fetchFromGitHub {
    owner = "Owl-Maintain";
    repo = "brlaser";
    tag = "v${version}";
    hash = "sha256-a+TjLmjqBz0b7v6kW1uxh4BGzrYOQ8aMdVo4orZeMT4=";
  };

  nativeBuildInputs = [
    cmake
    cups
  ];

  buildInputs = [
    zlib
    cups
  ];

  cmakeFlags = [
    "-DCUPS_SERVER_BIN=lib/cups"
    "-DCUPS_DATA_DIR=share/cups"
  ];

  meta = {
    description = "CUPS driver for Brother laser printers";
    longDescription = ''
      Although most Brother printers support a standard printer language such as PCL or PostScript, not all do. If you have a monochrome Brother laser printer (or multi-function device) and the other open source drivers don't work, this one might help.

      This driver is known to work with many printers in the DCP, HL and MFC series, along with a few others.
      See the homepage for a full list.
    '';
    homepage = "https://github.com/Owl-Maintain/brlaser";
    changelog = "https://github.com/Owl-Maintain/brlaser/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onny ];
  };
}
