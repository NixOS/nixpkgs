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
  version = "6.2.8";

  src = fetchFromGitHub {
    owner = "Owl-Maintain";
    repo = "brlaser";
    tag = "v${version}";
    hash = "sha256-fE3mKGrYPvLl66gVJJJPc3P3rBJk695SP7+3exE5exw=";
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
    # NOTE: this can be removed once version 6.2.8 is released
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
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
