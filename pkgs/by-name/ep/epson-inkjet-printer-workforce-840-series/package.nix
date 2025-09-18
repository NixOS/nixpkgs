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
stdenv.mkDerivation (finalAttrs: {
  pname = "epson-inkjet-printer-workforce-840-series";
  version = "1.0.0";

  # The Epson may be unreliable, and it has been since sometime in
  # 2024. Non-browser requests using commands like fetchurl receive a
  # 403 error, an access denied response -- last checked on
  # 2025-08-21.
  #
  # Therefore, an archive.org link has been added as a fallback
  # option just in case.
  src = fetchurl {
    # NOTE: Don't forget to update the webarchive link too!
    urls = [
      "https://download.ebz.epson.net/dsc/op/stable/SRPMS/epson-inkjet-printer-workforce-840-series-${finalAttrs.version}-1lsb3.2.src.rpm"
      "https://web.archive.org/web/https://download.ebz.epson.net/dsc/op/stable/SRPMS/epson-inkjet-printer-workforce-840-series-${finalAttrs.version}-1lsb3.2.src.rpm"
    ];
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

  # Both patches fix errors that occur when building with GCC 14.
  #
  # eps_raster_print-cast.patch fixes 'error: passing argument 5 of
  # ‘eps_raster_print’ from incompatible pointer type' in file
  # raster_to_epson.c
  #
  # include-raster-helper.patch fixes 'error: implicit declaration of
  # function' in files pagemanager.c and raster_to_epson.c
  patches = [
    ./eps_raster_print-cast.patch
    ./include-raster-helper.patch
  ];

  installPhase =
    let
      filterdir = "$out/lib/cups/filter";
      docdir = "$out/share/doc/epson-inkjet-printer-workforce-840-series";
      ppddir = "$out/share/cups/model/epson-inkjet-printer-workforce-840-series";
      libdir =
        if stdenv.hostPlatform.isx86_64 then
          "lib64"
        else
          throw "Platforms other than x86_64-linux are not (yet) supported.";
    in
    ''
      runHook preInstall

      mkdir -p "$out" "${docdir}" "${filterdir}" "${ppddir}"
      cp src/epson_inkjet_printer_filter "${filterdir}"

      cp AUTHORS COPYING COPYING.EPSON COPYING.LIB "${docdir}"

      cd ../${srcdirs.driver}
      cp Manual.txt README "${docdir}"
      for ppd in ppds/*; do
          substituteInPlace "$ppd" --replace-fail '/opt/epson-inkjet-printer-workforce-840-series/cups/lib' "$out/lib/cups"
          gzip -c "$ppd" > "${ppddir}/''${ppd#*/}"
      done
      cp -r resource watermark ${libdir} "$out"

      runHook postInstall
    '';

  meta = {
    description = "Proprietary CUPS drivers for Epson inkjet printers";
    longDescription = ''
      This software is a filter program used with the Common UNIX Printing
      System (CUPS) under Linux. It supplies high quality printing with
      Seiko Epson Color Ink Jet Printers.

      This printer driver is supporting the following printers.

      Epson Stylus Office BX925
      Epson WorkForce 840

      To use the driver adjust your configuration.nix file:
      ```nix
      {
        services.printing = {
          enable = true;
          drivers = [ pkgs.epson-inkjet-printer-workforce-840-series ];
        };
      }
      ```
    '';
    downloadPage = "http://download.ebz.epson.net/dsc/du/02/DriverDownloadInfo.do?LG2=EN&CN2=&DSCMI=16839&DSCCHK=3d7bc6bdfca08006abfb859fb1967183156a7252";
    license = with lib.licenses; [
      lgpl21
      epson
    ];
    maintainers = with lib.maintainers; [ heichro ];
    platforms = [ "x86_64-linux" ];
  };
})
