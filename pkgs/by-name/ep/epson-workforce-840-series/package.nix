{
  autoreconfHook,
  cups,
  libjpeg,
  rpmextract,
  fetchurl,
  lib,
  stdenv,
}:

let
  srcdirs = {
    filter = "epson-inkjet-printer-filter-1.0.0";
    driver = "epson-inkjet-printer-workforce-840-series-1.0.0";
  };
in
stdenv.mkDerivation rec {
  pname = "epson-inkjet-printer-workforce-840-series";
  version = "1.0.0";

  src = fetchurl {
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download.ebz.epson.net/dsc/op/stable/SRPMS/${pname}-${version}-1lsb3.2.src.rpm"
      "https://web.archive.org/web/https://download.ebz.epson.net/dsc/op/stable/SRPMS/${pname}-${version}-1lsb3.2.src.rpm"
    ];
    # webarchive hash
    hash = "sha256-rTYnEmgzqR/wOZYYIe2rO9x2cX8s2qDyTuRaTjzJjbg=";
  };
  sourceRoot = srcdirs.filter;

  nativeBuildInputs = [
    autoreconfHook
    rpmextract
  ];
  buildInputs = [
    cups
    libjpeg
  ];

  unpackPhase = ''
    runHook preUnpack

    rpmextract "$src"
    for i in ${lib.concatStringsSep " " (builtins.attrValues srcdirs)}; do
        tar xvf "$i".tar.gz
    done

    runHook postUnpack
  '';

  patches = [
    ./eps_raster_print-cast.patch
    ./include-raster-helper.patch
  ];

  preConfigure = ''
    chmod u+x configure
  '';

  installPhase =
    let
      filterdir = "$out/cups/lib/filter";
      docdir = "$out/share/doc";
      ppddir = "$out/share/cups/model/${pname}";
      libdir =
        if stdenv.system == "x86_64-linux" then
          "lib64"
        else if stdenv.system == "i686_linux" then
          "lib"
        else
          throw "other platforms than i686_linux and x86_64-linux are not yet supported";
    in
    ''
      runHook preInstall

      mkdir -p "$out" "${docdir}" "${filterdir}" "${ppddir}"
      cp src/epson_inkjet_printer_filter "${filterdir}"

      cd ../${srcdirs.driver}
      for ppd in ppds/*; do
          substituteInPlace "$ppd" --replace '/opt/${pname}' "$out"
          gzip -c "$ppd" > "${ppddir}/''${ppd#*/}"
      done
      cp COPYING.EPSON README "${docdir}"
      cp -r resource watermark ${libdir} "$out"

      runHook postInstall
    '';

  meta = with lib; {
    description = "Proprietary CUPS drivers for Epson inkjet printers";
    longDescription = ''
      This software is a filter program used with the Common UNIX Printing
      System (CUPS) under Linux. This can supply the high quality print
      with Seiko Epson Color Ink Jet Printers.

      This printer driver is supporting the following printers.

      Epson Stylus Office BX925
      Epson WorkForce 840

      License: LGPL and SEIKO EPSON CORPORATION SOFTWARE LICENSE AGREEMENT

      To use the driver adjust your configuration.nix file:
        services.printing = {
          enable = true;
          drivers = [ pkgs.${pname} ];
        };
    '';
    downloadPage = "http://download.ebz.epson.net/dsc/du/02/DriverDownloadInfo.do?LG2=EN&CN2=&DSCMI=16839&DSCCHK=3d7bc6bdfca08006abfb859fb1967183156a7252";
    license = with licenses; [
      lgpl21
      epson
    ];
    maintainers = with maintainers; [ heichro ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
