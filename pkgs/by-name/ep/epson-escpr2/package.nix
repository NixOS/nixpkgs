{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  cups,
}:

stdenv.mkDerivation {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.2.36";

  src = fetchurl {
    # To find the most recent version go to
    # https://support.epson.net/linux/Printer/LSB_distribution_pages/en/escpr2.php
    # and retrieve the download link for source package for arm CPU for the tar.gz (the x86 link targets to rpm source files)

    url = "https://download-center.epson.com/f/module/bb48b7e6-662f-4152-a86f-c1a78fc74b1f/epson-inkjet-printer-escpr2-1.2.36-1.tar.gz";
    hash = "sha256-0R4dFhT1XhjXMOeRxCbTIT1K83bkwiAhpu/W10DSlxM=";
  };

  buildInputs = [ cups ];
  nativeBuildInputs = [
    autoreconfHook
  ];

  patches = [
    # Fixes "implicit declaration of function" errors
    # source of patch: https://aur.archlinux.org/packages/epson-inkjet-printer-escpr2
    (fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/bug_x86_64.patch?h=epson-inkjet-printer-escpr2&id=8fbca325d6d39fa3ffe001f90a432380bdeacc2f";
      sha256 = "sha256-V8ejK33qyHPX4x8EOgR+XWW44KR8DQwHx2w+O71gQwo=";
    })
  ];

  configureFlags = [
    "--with-cupsfilterdir=${placeholder "out"}/lib/cups/filter"
    "--with-cupsppddir=${placeholder "out"}/share/cups/model"
  ];

  passthru.updateScript = ./update.sh;

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
