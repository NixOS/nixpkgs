{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  cups,
}:

stdenv.mkDerivation {
  pname = "epson-inkjet-printer-escpr2";
  version = "1.2.35";

  src = fetchurl {
    # To find the most recent version go to
    # https://support.epson.net/linux/Printer/LSB_distribution_pages/en/escpr2.php
    # and retrieve the download link for source package for arm CPU for the tar.gz (the x86 link targets to rpm source files)
    url = "https://download3.ebz.epson.net/dsc/f/03/00/17/28/09/4e8dc40219d4b52e414b608de92552af4fd46eca/epson-inkjet-printer-escpr2-1.2.35-1.tar.gz";
    hash = "sha256-aYEuEION/C32/SnngreX/nqK/6Yzkuxf0k0HpferTYM=";
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
