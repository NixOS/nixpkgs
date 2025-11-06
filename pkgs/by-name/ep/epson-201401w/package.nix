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
  version = "1.0.0";
  filterVersion = "1.0.0";
in
stdenv.mkDerivation {
  pname = "epson-201401w";
  inherit version;

  src = fetchurl {
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/03/45/41/92e9c9254f0ee4230a069545ba27ec2858a2c457/epson-inkjet-printer-201401w-1.0.0-1lsb3.2.src.rpm"
      "https://web.archive.org/web/20200725175832/https://download3.ebz.epson.net/dsc/f/03/00/03/45/41/92e9c9254f0ee4230a069545ba27ec2858a2c457/epson-inkjet-printer-201401w-1.0.0-1lsb3.2.src.rpm"
    ];
    sha256 = "0c60m1sd59s4sda38dc5nniwa7dh1b0kv1maajr0x9d38gqlyk3x";
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
    tar -zxf epson-inkjet-printer-201401w-${version}.tar.gz
    tar -zxf epson-inkjet-printer-filter-${filterVersion}.tar.gz
    for ppd in epson-inkjet-printer-201401w-${version}/ppds/*; do
      substituteInPlace $ppd --replace "/opt/epson-inkjet-printer-201401w" "$out"
      substituteInPlace $ppd --replace "/cups/lib" "/lib/cups"
    done
    cd epson-inkjet-printer-filter-${filterVersion}
  '';

  preConfigure = ''
    chmod +x configure
  '';

  postInstall = ''
    cd ../epson-inkjet-printer-201401w-${version}
    cp -a lib64 resource watermark $out
    mkdir -p $out/share/cups/model/epson-inkjet-printer-201401w
    cp -a ppds $out/share/cups/model/epson-inkjet-printer-201401w/
    cp -a Manual.txt $out/doc/
    cp -a README $out/doc/README.driver
  '';

  meta = with lib; {
    homepage = "https://www.openprinting.org/driver/epson-201401w";
    description = "Epson printer driver (L456, L455, L366, L365, L362, L360, L312, L310, L222, L220, L132, L130)";
    longDescription = ''
      This software is a filter program used with the Common UNIX Printing
      System (CUPS) under Linux. It supplies high quality printing with
      Seiko Epson Color Ink Jet Printers.

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.epson-201401w ];
        };
    '';
    license = with licenses; [
      lgpl21
      epson
    ];
    platforms = platforms.linux;
    maintainers = [ maintainers.lunarequest ];
  };
}
