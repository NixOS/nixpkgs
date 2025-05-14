{
  lib,
  stdenv,
  fetchurl,
  rpmextract,
  autoreconfHook,
  file,
  libjpeg,
  cups,
}:

let
  version = "1.0.1";
  filterVersion = "1.0.2";
in
stdenv.mkDerivation {

  pname = "epson_201207w";
  inherit version;

  src = fetchurl {
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/15/64/87/25d34a13841e5e95d80266e6fd8dfcdf67c95634/epson-inkjet-printer-201207w-1.0.1-1.src.rpm"
      "https://web.archive.org/web/https://download3.ebz.epson.net/dsc/f/03/00/15/64/87/25d34a13841e5e95d80266e6fd8dfcdf67c95634/epson-inkjet-printer-201207w-1.0.1-1.src.rpm"
    ];
    sha256 = "0icbsd3m8ij1zm55q8vms81dxd79nf5m33i2g4knddljsfv7nxdc";
  };

  nativeBuildInputs = [
    rpmextract
    autoreconfHook
    file
  ];

  buildInputs = [
    libjpeg
    cups
  ];

  unpackPhase = ''
    rpmextract $src
    tar -zxf epson-inkjet-printer-201207w-${version}.tar.gz
    tar -zxf epson-inkjet-printer-filter-${filterVersion}.tar.gz
    for ppd in epson-inkjet-printer-201207w-${version}/ppds/*; do
      substituteInPlace $ppd --replace "/opt/epson-inkjet-printer-201207w" "$out"
      substituteInPlace $ppd --replace "/cups/lib" "/lib/cups"
    done
    cd epson-inkjet-printer-filter-${filterVersion}
  '';

  preConfigure = ''
    chmod +x configure
    export LDFLAGS="$LDFLAGS -Wl,--no-as-needed"
  '';

  postInstall = ''
    cd ../epson-inkjet-printer-201207w-${version}
    cp -a lib64 resource watermark $out
    mkdir -p $out/share/cups/model/epson-inkjet-printer-201207w
    cp -a ppds $out/share/cups/model/epson-inkjet-printer-201207w/
    cp -a Manual.txt $out/doc/
    cp -a README $out/doc/README.driver
  '';

  meta = with lib; {
    homepage = "https://www.openprinting.org/driver/epson-201207w";
    description = "Epson printer driver (L110, L210, L300, L350, L355, L550, L555)";
    longDescription = ''
      This software is a filter program used with the Common UNIX Printing
      System (CUPS) under Linux. It supplies high quality printing with
      Seiko Epson Color Ink Jet Printers.

      List of printers supported by this package:
         Epson L110 Series
         Epson L210 Series
         Epson L300 Series
         Epson L350 Series
         Epson L355 Series
         Epson L550 Series
         Epson L555 Series

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.epson_201207w ];
        };
    '';
    license = with licenses; [
      lgpl21Plus
      epson
    ];
    maintainers = [ maintainers.romildo ];
    platforms = [ "x86_64-linux" ];
  };

}
