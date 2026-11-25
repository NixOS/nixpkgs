{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  patchelf,
  pkgsi686Linux,
  mfc1810lpr,
  coreutils,
  gnugrep,
  gnused,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "mfc1810cupswrapper";
  version = "3.0.1-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf100416/${pname}-${version}.i386.deb";
    hash = "sha256-TfZBmYz73c5NM2Qu5ZQEnRJAISraSxmBI4b5AxcR1Pw=";
  };

  nativeBuildInputs = [
    dpkg
    patchelf
    makeWrapper
  ];

  unpackPhase = ''
    runHook preUnpack
    mkdir src && cd src
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    lpr=${mfc1810lpr}/opt/brother/Printers/MFC1810
    dir=$out/opt/brother/Printers/MFC1810

    mkdir -p $out
    cp -r opt $out/

    # brcupsconfig4 ships here as a 32-bit i386 binary, same as mfc1810lpr's
    for f in $(find $out -type f); do
      if patchelf --print-interpreter "$f" >/dev/null 2>&1; then
        chmod +x "$f"
        patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 "$f"
      fi
    done

    # The wrapper script build /opt/brother/Printers/$PRINTER using a var
    f=$dir/cupswrapper/brother_lpdwrapper_MFC1810
    substituteInPlace "$f" \
      --replace-fail 'BASEDIR=/opt/brother/Printers/$PRINTER/' "BASEDIR=$lpr/" \
      --replace-fail '/opt/brother/Printers/$PRINTER//inf/brMFC1810rc' "$lpr/inf/brMFC1810rc" \
      --replace-fail '/opt/brother/Printers/$PRINTER//cupswrapper/brcupsconfig4' "$dir/cupswrapper/brcupsconfig4"

    mkdir -p $out/lib/cups/filter $out/share/cups/model
    ln -s $dir/cupswrapper/brother_lpdwrapper_MFC1810 $out/lib/cups/filter/brother_lpdwrapper_MFC1810
    ln -s $dir/cupswrapper/brother-MFC1810-cups-en.ppd $out/share/cups/model/brother-MFC1810-cups-en.ppd

    chmod +x $dir/cupswrapper/brother_lpdwrapper_MFC1810
    wrapProgram $dir/cupswrapper/brother_lpdwrapper_MFC1810 --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        gnugrep
        gnused
      ]
    }

    runHook postInstall
  '';

  meta = {
    description = "Brother MFC-1810 CUPS wrapper driver";
    longDescription = "CUPS wrapper and PPD for the Brother MFC-1810 (USB). Use together with mfc1810lpr.";
    homepage = "https://support.brother.com/g/b/producttop.aspx?c=gb&lang=en&prod=mfc1810_all";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2Plus;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with lib.maintainers; [ ee5cd7d5d ];
  };
}
