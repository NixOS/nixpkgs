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
  filterversion = "1.0.2";
in
stdenv.mkDerivation {

  pname = "epson_201601w";
  inherit version;

  src = fetchurl {
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download3.ebz.epson.net/dsc/f/03/00/15/66/51/1046e0a9f8d8ec892806a8d4921335cf6f5fd1ea/epson-inkjet-printer-201601w-${version}-1.src.rpm"
      "https://web.archive.org/web/20240601191136/https://download3.ebz.epson.net/dsc/f/03/00/15/66/51/1046e0a9f8d8ec892806a8d4921335cf6f5fd1ea/epson-inkjet-printer-201601w-${version}-1.src.rpm"
    ];
    hash = "sha256-BI1y3U3EvVqqFfQ7YnQxiuIby6GJ5B0TCC2jQH1Uos0=";
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
    tar -zxf epson-inkjet-printer-201601w-${version}.tar.gz
    tar -zxf epson-inkjet-printer-filter-${filterversion}.tar.gz
    for ppd in epson-inkjet-printer-201601w-${version}/ppds/*; do
      substituteInPlace $ppd --replace "/opt/epson-inkjet-printer-201601w" "$out"
      substituteInPlace $ppd --replace "/cups/lib" "/lib/cups"
    done
    cd epson-inkjet-printer-filter-${filterversion}
  '';

  preConfigure = ''
    chmod +x configure
    export LDFLAGS="$LDFLAGS -Wl,--no-as-needed"
  '';

  postInstall = ''
    cd ../epson-inkjet-printer-201601w-${version}
    cp -a lib64 resource watermark $out
    mkdir -p $out/share/cups/model/epson-inkjet-printer-201601w
    cp -a ppds $out/share/cups/model/epson-inkjet-printer-201601w/
    cp -a Manual.txt $out/doc/
    cp -a README $out/doc/README.driver
  '';

  meta = {
    homepage = "https://download.ebz.epson.net/dsc/du/02/DriverDownloadInfo.do?LG2=EN&CN2=&DSCMI=156651&DSCCHK=0ee68ffad69c21e7c0cedbbfe22494f7bb8e1eb7";
    description = "Epson printer driver (L380/L382)";
    longDescription = ''
      This software is a filter program used with the Common UNIX Printing
      System (CUPS) under Linux. It supplies high quality printing with
      Seiko Epson Color Ink Jet Printers.

      List of printers supported by this package:
         Epson L380 Series
         Epson L382 Series

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.epson_201601w ];
        };

      Note: Consider to use epson-201401w > L310 Driver if you have color/resolution issues
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [
      lgpl21Only
      epson
    ];
    maintainers = [ lib.maintainers.asandikci ];
    platforms = [ "x86_64-linux" ];
  };
}
