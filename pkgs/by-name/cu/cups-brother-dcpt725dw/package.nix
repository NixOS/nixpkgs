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
  pname = "cups-brother-dcpt725dw";
  version = "3.5.0-1";
  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105181/dcpt725dwpdrv-${version}.i386.deb";
    hash = "sha256-fK6RHaW/ej1nFgSaTbzWxVgjIW32YTbJbd1xD37ZE7c=";
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

    LPDDIR=$out/opt/brother/Printers/dcpt725dw/lpd
    WRAPPER=$out/opt/brother/Printers/dcpt725dw/cupswrapper/brother_lpdwrapper_dcpt725dw

    ln -s $LPDDIR/${stdenv.hostPlatform.linuxArch}/* $LPDDIR/

    substituteInPlace $WRAPPER \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpt725dw\"; #" \
      --replace-fail "basedir =~" "basedir = \"$out/opt/brother/Printers/dcpt725dw/\"; #" \
      --replace-fail "lpdconf = " "lpdconf = \$lpddir.'/'.\$LPDCONFIGEXE.\$PRINTER; #" \
      --replace-fail "\$DEBUG=0;" "\$DEBUG=${debugLvl};"

    substituteInPlace $LPDDIR/filter_dcpt725dw \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/dcpt725dw/\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpt725dw\"; #"

    wrapProgram $WRAPPER \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
        ]
      }

    wrapProgram $LPDDIR/filter_dcpt725dw \
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
      $LPDDIR/brdcpt725dwfilter

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/brprintconf_dcpt725dw

    wrapProgram $LPDDIR/brprintconf_dcpt725dw \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    wrapProgram $LPDDIR/brdcpt725dwfilter \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    mkdir -p "$out/lib/cups/filter" "$out/share/cups/model"

    ln -s $out/opt/brother/Printers/dcpt725dw/cupswrapper/brother_lpdwrapper_dcpt725dw \
      $out/lib/cups/filter/brother_lpdwrapper_dcpt725dw

    ln -s "$out/opt/brother/Printers/dcpt725dw/cupswrapper/brother_dcpt725dw_printer_en.ppd" \
      "$out/share/cups/model/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Brother DCP-T725DW printer driver";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ u2x1 ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    downloadPage = "https://support.brother.com/g/b/downloadtop.aspx?c=cn_ot&lang=en&prod=dcpt725dw_cn";
    homepage = "http://www.brother.com/";
  };
}
