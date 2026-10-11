{
  lib,
  dpkg,
  file,
  perl,
  gnused,
  stdenv,
  gnugrep,
  fetchurl,
  coreutils,
  makeWrapper,
  ghostscript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mfcj1010dw";
  version = "3.5.0-1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf105358/${finalAttrs.pname}pdrv-${finalAttrs.version}.i386.deb";
    hash = "sha256-8kPPJVHRSkbBtbRpChyToGmT9JnuGbqdQXYq5nF1WqI=";
  };

  nativeBuildInputs = [
    dpkg
    perl
    makeWrapper
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src $out

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    dir="$out/opt/brother/Printers/${finalAttrs.pname}"

    patchShebangs --build "$dir"

    substituteInPlace "$dir/cupswrapper/cupswrapper${finalAttrs.pname}" \
      --replace-fail /opt "$out/opt" \
      --replace-fail /usr "$out/usr" \
      --replace-fail /etc "$out/etc"


    wrapProgram "$dir/inf/setupPrintcapij" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
        ]
      }

    wrapProgram "$dir/lpd/filter_${finalAttrs.pname}" \
      --prefix PATH : ${
        lib.makeBinPath [
          file
          gnused
          coreutils
          ghostscript
        ]
      }

    substituteInPlace "$dir/cupswrapper/brother_lpdwrapper_${finalAttrs.pname}" \
      --replace-fail "$PRINTER =~ s/^\/opt\/.*\/Printers\///g;" "$PRINTER =~ s/^.*\/opt\/.*\/Printers\///g;"

    wrapProgram "$dir/cupswrapper/brother_lpdwrapper_${finalAttrs.pname}" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
        ]
      }

    PPDFOLDER="$out/share/cups/model"
    FILTERFOLDER="$out/lib/cups/filter"

    mkdir -p "$PPDFOLDER" "$FILTERFOLDER"

    ln -s "$dir/cupswrapper/brother_${finalAttrs.pname}_printer_en.ppd" "$PPDFOLDER/brother_${finalAttrs.pname}_printer_en.ppd"
    ln -s "$dir/cupswrapper/brother_lpdwrapper_${finalAttrs.pname}" "$FILTERFOLDER/brother_lpdwrapper_${finalAttrs.pname}"

    runHook postInstall
  '';

  meta = {
    description = "Brother MFC-J1010DW CUPS printer driver";
    homepage = "https://www.brother.com/";
    license = with lib.licenses; [
      gpl2Only # opt/brother/Printers/mfcj1010dw/cupswrapper (share/cups/model, lib/cups/filter)
      unfreeRedistributable # rest
    ];
    maintainers = with lib.maintainers; [ kybe236 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
