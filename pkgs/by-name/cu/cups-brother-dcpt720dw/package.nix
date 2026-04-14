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
  makeBinaryWrapper,
  libredirect,
  debugLvl ? "0",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cups-brother-dcpt720dw";
  version = "3.5.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105179/dcpt720dwpdrv-${finalAttrs.version}.i386.deb";
    hash = "sha256-ToUFGnHxd6rnLdfhdDGzhvsgFJukEAVzlm79hmkSV3E=";
  };

  strictDeps = true;
  buildInputs = [ perl ];
  nativeBuildInputs = [
    dpkg
    makeBinaryWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg-deb -x $src $out

    LPDDIR=$out/opt/brother/Printers/dcpt720dw/lpd
    WRAPPER=$out/opt/brother/Printers/dcpt720dw/cupswrapper/brother_lpdwrapper_dcpt720dw

    ln -s $LPDDIR/${stdenv.hostPlatform.linuxArch}/* $LPDDIR/

    substituteInPlace $WRAPPER \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpt720dw\"; #" \
      --replace-fail "basedir =~" "basedir = \"$out/opt/brother/Printers/dcpt720dw/\"; #" \
      --replace-fail "lpdconf = " "lpdconf = \$lpddir.'/'.\$LPDCONFIGEXE.\$PRINTER; #" \
      --replace-fail "\$DEBUG=0;" "\$DEBUG=${debugLvl};"

    substituteInPlace $LPDDIR/filter_dcpt720dw \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/dcpt720dw/\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpt720dw\"; #"

    wrapProgram $WRAPPER \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
        ]
      }

    wrapProgram $LPDDIR/filter_dcpt720dw \
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
      $LPDDIR/brdcpt720dwfilter

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/brprintconf_dcpt720dw

    wrapProgram $LPDDIR/brprintconf_dcpt720dw \
      --set LD_PRELOAD "${lib.getLib libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    wrapProgram $LPDDIR/brdcpt720dwfilter \
      --set LD_PRELOAD "${lib.getLib libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    mkdir -p "$out/lib/cups/filter" "$out/share/cups/model"

    ln -s $out/opt/brother/Printers/dcpt720dw/cupswrapper/brother_lpdwrapper_dcpt720dw \
      $out/lib/cups/filter/brother_lpdwrapper_dcpt720dw

    ln -s "$out/opt/brother/Printers/dcpt720dw/cupswrapper/brother_dcpt720dw_printer_en.ppd" \
      "$out/share/cups/model/"

    runHook postInstall
  '';

  meta = {
    description = "Brother DCP-T720DW printer driver";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ mimahlavacek ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    downloadPage = "https://support.brother.com/g/b/downloadtop.aspx?c=cn_ot&lang=en&prod=dcpt720dw_all";
    homepage = "http://www.brother.com/";
  };
})
