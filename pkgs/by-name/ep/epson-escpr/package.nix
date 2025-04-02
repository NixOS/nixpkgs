{
  lib,
  stdenv,
  fetchurl,
  cups,
}:

let
  version = "1.7.20";
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
      "https://download3.ebz.epson.net/dsc/f/03/00/13/76/45/5ac2ea8f9cf94a48abd64afd0f967f98c4fc24aa/epson-inkjet-printer-escpr-${version}-1lsb3.2.tar.gz"

      "https://web.archive.org/web/https://download3.ebz.epson.net/dsc/f/03/00/13/76/45/5ac2ea8f9cf94a48abd64afd0f967f98c4fc24aa/epson-inkjet-printer-escpr-${version}-1lsb3.2.tar.gz"
    ];
    sha256 = "sha256:09rscpm557dgaflylr93wcwmyn6fnvr8nc77abwnq97r6hxwrkhk";
  };

  patches = [ ./cups-filter-ppd-dirs.patch ];

  buildInputs = [ cups ];

  meta = with lib; {
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artuuge ];
    platforms = platforms.linux;
  };
}
