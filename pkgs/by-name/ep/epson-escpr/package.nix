{
  lib,
  stdenv,
  fetchurl,
  cups,
  fetchpatch,
  dos2unix,
  automake115x,
  autoconf,
}:

let
  version = "1.8.6-1";
in
stdenv.mkDerivation {
  pname = "epson-escpr";
  inherit version;

  src = fetchurl {
    # To find new versions, visit
    # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
    # some printer like for instance "WF-7110" to get to the most recent
    # version.
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/16/21/81/74d098a47c3a616713079c9cd5904b468bb33dea/epson-inkjet-printer-escpr-${version}.tar.gz"

      "https://web.archive.org/web/https://download3.ebz.epson.net/dsc/f/03/00/16/21/81/74d098a47c3a616713079c9cd5904b468bb33dea/epson-inkjet-printer-escpr-${version}.tar.gz"
    ];
    sha256 = "sha256-hVbX4OXPe4y37Szju3uVdXlVdjX4DFSN/A2Emz3eCcQ=";
  };
  # DOS Line Endings in /lib directory and UNIX Line endings in /src directory.
  # So convert everything to UNIX style line endings.
  # Since the files are modified, autoconf and automake is required
  postUnpack = ''
    dir=''${src%-*}
    cd ''${dir#*-}
    local f
    for f in $(find ./ -type f || die); do
      ${dos2unix}/bin/dos2unix $f
    done
    cd ..
  '';

  patches = [
    ./cups-filter-ppd-dirs.patch
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-print/epson-inkjet-printer-escpr/files/epson-inkjet-printer-escpr-1.8-missing-include.patch";
      hash = "sha256-L4WhaxPQnJYyqCH00wiKIlFNMmCEXoGe5d7hJ5TMyEI=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/net-print/epson-inkjet-printer-escpr/files/1.8.6-warnings.patch";
      hash = "sha256-wSY0LZv2b+1kF7TfPolt554g79y2Ce6N/JqgjJyd3Ag=";
    })
  ];

  # To suppress error (Stripping trailing CRs from patch; use --binary to disable.)
  patchFlags = [
    "-p1"
  ];
  buildInputs = [ cups ];
  nativeBuildInputs = [
    automake115x
    autoconf
  ];

  meta = {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/";
    description = "ESC/P-R Driver (generic driver)";
    longDescription = ''
      Epson Inkjet Printer Driver (ESC/P-R) for Linux and the
      corresponding PPD files. The list of supported printers
      can be found at http://www.openprinting.org/driver/epson-escpr/ .

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.epson-escpr ];
        };

      To setup a wireless printer, enable Avahi which provides
      printer's hostname to CUPS and nss-mdns to make this
      hostname resolvable:
        services.avahi = {
          enable = true;
          nssmdns4 = true;
        };'';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ artuuge ];
    platforms = lib.platforms.linux;
  };
}
