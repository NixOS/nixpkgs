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

let
  printerName = "DCP-T720DW";
  model = "dcpt720dw";
  version = "3.5.0-1";
  debHash = "sha256-ToUFGnHxd6rnLdfhdDGzhvsgFJukEAVzlm79hmkSV3E=";
in
# Based on cups-brother-dcpt725dw package
stdenv.mkDerivation {
  pname = "cups-brother-${model}";
  inherit version;
  src = fetchurl {
    # The URL used by the official linux-brprinter-installer. Switched from
    # https://download.brother.com/welcome/dlf<fileno> used by other
    # nix packages, avoiding the need for hard-coding the `fileno` identifier.
    url = "https://download.brother.com/pub/com/linux/linux/packages/${model}pdrv-${version}.i386.deb";
    hash = debHash;
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];
  buildInputs = [ perl ];

  unpackPhase = ''
    runHook preUnpack
    mkdir -p $out
    dpkg-deb -x $src $out
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    LPDDIR=$out/opt/brother/Printers/${model}/lpd
    WRAPPER=$out/opt/brother/Printers/${model}/cupswrapper/brother_lpdwrapper_${model}

    ln -s $LPDDIR/${stdenv.hostPlatform.linuxArch}/* $LPDDIR/

    substituteInPlace $WRAPPER \
      --replace-fail "PRINTER =~" "PRINTER = \"${model}\"; #" \
      --replace-fail "basedir =~" "basedir = \"$out/opt/brother/Printers/${model}/\"; #" \
      --replace-fail "lpdconf = " "lpdconf = \$lpddir.'/'.\$LPDCONFIGEXE.\$PRINTER; #" \
      --replace-fail "\$DEBUG=0;" "\$DEBUG=${debugLvl};"

    substituteInPlace $LPDDIR/filter_${model} \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/${model}/\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"${model}\"; #"

    wrapProgram $WRAPPER \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
        ]
      }

    wrapProgram $LPDDIR/filter_${model} \
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
      $LPDDIR/br${model}filter

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $LPDDIR/brprintconf_${model}

    wrapProgram $LPDDIR/brprintconf_${model} \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    wrapProgram $LPDDIR/br${model}filter \
      --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    mkdir -p "$out/lib/cups/filter" "$out/share/cups/model"

    ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_lpdwrapper_${model} \
      $out/lib/cups/filter/brother_lpdwrapper_${model}

    ln -s "$out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd" \
      "$out/share/cups/model/"

    runHook postInstall
  '';

  meta = {
    description = "Brother ${printerName} printer driver";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ jmendyk ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=pl&lang=pl&prod=${model}_all&os=128&flang=English";
    homepage = "http://www.brother.com/";
  };
}
