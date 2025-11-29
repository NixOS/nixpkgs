{
  stdenv,
  lib,
  fetchurl,
  perl,
  ghostscript,
  coreutils,
  gnugrep,
  which,
  file,
  gnused,
  dpkg,
  makeWrapper,
  libredirect,
  debugLvl ? "0",
}:

stdenv.mkDerivation rec {
  pname = "cups-brother-dcpt730dw";
  version = "3.6.1-1";
  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf106527/dcpt730dwpdrv-${version}.amd64.deb";
    hash = "sha256-tEC2iNa+LpqaaaK/TfP1bJDVLhSYWLz944VesMoFGJA=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];
  buildInputs = [ perl ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg-deb -x $src $out

    LPDDIR=$out/opt/brother/Printers/dcpt730dw/lpd
    WRAPPER=$out/opt/brother/Printers/dcpt730dw/cupswrapper/brother_lpdwrapper_dcpt730dw

    ln -s $LPDDIR/${stdenv.hostPlatform.linuxArch}/* $LPDDIR/

    substituteInPlace $WRAPPER \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpt730dw\"; #" \
      --replace-fail "basedir =~" "basedir = \"$out/opt/brother/Printers/dcpt730dw/\"; #" \
      --replace-fail "lpdconf = " "lpdconf = \$lpddir.'/'.\$LPDCONFIGEXE.\$PRINTER; #" \
      --replace-fail "\$DEBUG=0;" "\$DEBUG=${debugLvl};"

    substituteInPlace $LPDDIR/filter_dcpt730dw \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/dcpt730dw/\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpt730dw\"; #"

    wrapProgram $WRAPPER \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
        ]
      }

    wrapProgram $LPDDIR/filter_dcpt730dw \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          ghostscript
          gnugrep
          gnused
          which
          file
        ]
      }

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/brdcpt730dwfilter

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/brprintconf_dcpt730dw

    wrapProgram $LPDDIR/brprintconf_dcpt730dw \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    wrapProgram $LPDDIR/brdcpt730dwfilter \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    mkdir -p "$out/lib/cups/filter" "$out/share/cups/model"

    ln -s $out/opt/brother/Printers/dcpt730dw/cupswrapper/brother_lpdwrapper_dcpt730dw \
      $out/lib/cups/filter/brother_lpdwrapper_dcpt730dw

    ln -s "$out/opt/brother/Printers/dcpt730dw/cupswrapper/brother_dcpt730dw_printer_en.ppd" \
      "$out/share/cups/model/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Brother DCP-T730DW printer driver";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ u2x1 ];
    platforms = [
      "x86_64-linux"
    ];
    downloadPage = "https://support.brother.com/g/b/downloadtop.aspx?c=cn_ot&lang=en&prod=dcpt730dw_cn";
    homepage = "http://www.brother.com/";
  };
}
