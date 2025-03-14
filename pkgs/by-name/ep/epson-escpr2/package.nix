{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  cups,
}:

stdenv.mkDerivation {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.2.28";

  src = fetchurl {
    # To find the most recent version go to
    # https://support.epson.net/linux/Printer/LSB_distribution_pages/en/escpr2.php
    # and retrieve the download link for source package for arm CPU for the tar.gz (the x86 link targets to rpm source files)
    url = "https://download3.ebz.epson.net/dsc/f/03/00/16/80/15/8bd63ccd14a1966e9c3658d374686c5bb104bb04/epson-inkjet-printer-escpr2-1.2.28-1.tar.gz";
    hash = "sha256-lv8Hgo7JzT4igY8ek7EXdyFO34l735dpMC+gWkO5rvY=";
  };

  buildInputs = [ cups ];
  nativeBuildInputs = [
    autoreconfHook
  ];

  patches = [
    # Fixes "implicit declaration of function" errors
    # source of patch: https://aur.archlinux.org/packages/epson-inkjet-printer-escpr2
    (fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/bug_x86_64.patch?h=epson-inkjet-printer-escpr2&id=575d1b959063044f233cca099caceec8e6d5c02f";
      sha256 = "sha256-G6/3oj25FUT+xv9aJ7qP5PBZWLfy+V8MCHUYucDhtzM=";
    })
  ];

  configureFlags = [
    "--with-cupsfilterdir=${builtins.placeholder "out"}/lib/cups/filter"
    "--with-cupsppddir=${builtins.placeholder "out"}/share/cups/model"
  ];

  meta = {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
    description = "ESC/P-R 2 Driver (generic driver)";
    longDescription = ''
      Epson Inkjet Printer Driver 2 (ESC/P-R 2) for Linux and the
      corresponding PPD files.

      Refer to the description of epson-escpr for usage.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ma9e
      ma27
      shawn8901
    ];
    platforms = lib.platforms.linux;
  };
}
