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
  version = "1.0.2";
in
stdenv.mkDerivation {
  pname = "epson-202101w";
  inherit version;

  src = fetchurl {
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/15/15/02/f5cba2761f2f501363cdbf7e1b9b9879b0715aa5/epson-inkjet-printer-202101w-1.0.2-1.src.rpm"
      "https://web.archive.org/web/20250609030209if_/https://download3.ebz.epson.net/dsc/f/03/00/15/15/02/f5cba2761f2f501363cdbf7e1b9b9879b0715aa5/epson-inkjet-printer-202101w-1.0.2-1.src.rpm"
    ];
    sha256 = "17lz5cccknabp8cbkplhv1sn92m5w5md01rhhycbngp10zdmyhcz";
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
    tar -zxf epson-inkjet-printer-202101w-${version}.tar.gz
    tar -zxf epson-inkjet-printer-filter-${version}.tar.gz
    for ppd in epson-inkjet-printer-202101w-${version}/ppds/*; do
      substituteInPlace $ppd --replace "/opt/epson-inkjet-printer-202101w" "$out"
      substituteInPlace $ppd --replace "/cups/lib" "/lib/cups"
    done
    cd epson-inkjet-printer-filter-${version}
  '';

  preConfigure = ''
    chmod +x configure
  '';

  postInstall = ''
    cd ../epson-inkjet-printer-202101w-${version}
    cp -a lib64 resource watermark $out
    mkdir -p $out/share/cups/model/epson-inkjet-printer-202101w
    cp -a ppds $out/share/cups/model/epson-inkjet-printer-202101w/
    cp -a Manual.txt $out/doc/
    cp -a README $out/doc/README.driver
  '';

  meta = {
    homepage = "https://www.openprinting.org/driver/epson-202101w";
    description = "Epson printer driver (L1210, L1250, L3200, L3210)";
    longDescription = ''
      This software is a filter program used with the Common UNIX Printing
      System (CUPS) under Linux. It supplies high quality printing with
      Seiko Epson Color Ink Jet Printers.

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.epson-202101w ];
        };
    '';
    license = with lib.licenses; [
      lgpl21
      epson
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      caguiclajmg
    ];
  };
}
