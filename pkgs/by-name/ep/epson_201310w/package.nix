{
  lib,
  stdenv,
  fetchurl,
  rpmextract,
  libjpeg,
  cups,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "epson_201310w";
  version = "1.0.1";

  src = fetchurl {
    url = "https://download3.ebz.epson.net/dsc/f/03/00/15/64/77/6f825c323a9f4b8429e3f9f0f4e9c50b1b15f583/epson-inkjet-printer-201310w-${finalAttrs.version}-1.src.rpm";
    hash = "sha256-596qMon5KmMHe7mh+ykdpWeazJOCGA6HmmtvdGheRmA=";
  };

  nativeBuildInputs = [ rpmextract ];

  buildInputs = [
    libjpeg
    cups
  ];

  unpackPhase = ''
    runHook preUnpack
    rpmextract $src
    tar -zxf epson-inkjet-printer-201310w-1.0.1.tar.gz
    tar -zxf epson-inkjet-printer-filter-1.0.2.tar.gz
    runHook postUnpack
  '';

  preConfigure = ''
    cd epson-inkjet-printer-filter-1.0.2
  '';

  postInstall = ''
    cd ../epson-inkjet-printer-201310w-1.0.1
    cp -a lib64 resource watermark $out
    install --mode=0644 -Dt $out/share/cups/model ppds/EPSON_L120.ppd
    mkdir -p $out/doc
    cp -a Manual.txt $out/doc
    cp -a README $out/doc/README.driver
  '';

  postFixup = ''
    substituteInPlace $out/share/cups/model/EPSON_L120.ppd \
      --replace-fail "/home/epson/projects/PrinterDriver/P2/_rpmbuild/SOURCES/epson-inkjet-printer-201310w-1.0.1/watermark" "$out/watermark" \
      --replace-fail "Epson_201310w.1.data" "$out/resource/Epson_201310w.1.data"
  '';

  meta = {
    homepage = "https://www.epson.eu/en_EU/support/sc/epson-l120/s/s1346";
    description = "Epson printer driver for L120 series inkjet printers";
    longDescription = ''
      This software is a filter program used with the Common UNIX Printing
      System (CUPS) under Linux. It supplies high quality printing with
      Seiko Epson L120 series printers.

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.epson_201310w ];
        };
    '';
    license = with lib.licenses; [
      lgpl21
      epson
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ nukdokplex ];
    platforms = [ "x86_64-linux" ];
  };
})
