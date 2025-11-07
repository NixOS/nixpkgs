{
  lib,
  stdenvNoCC,
  pkgsi686Linux,
  fetchurl,
  cups,
  dpkg,
  gnused,
  makeWrapper,
  ghostscript,
  file,
  a2ps,
  coreutils,
  gawk,
}:

let
  version = "3.0.1-1";
  cupsdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101532/dcp1610wcupswrapper-${version}.i386.deb";
    hash = "sha256-ZgE2o/xU11+MzSnBYakXZE5m+Qa85/KIo31wKWAmsGY=";
  };
  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101533/dcp1610wlpr-${version}.i386.deb";
    hash = "sha256-hi0b23DgSXVT/fNA+Y2aJOdopt7SwjUyYyev81boGlg=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "cups-brother-dcp1610wlpr";
  inherit version;

  srcs = [
    cupsdeb
    lprdeb
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    cups
    ghostscript
    dpkg
    a2ps
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x ${lprdeb} $out
    dpkg-deb -x ${cupsdeb} $out

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/cups/filter $out/share/cups/model
    ln -s $out/opt/brother/Printers/DCP1610W/cupswrapper/brother_lpdwrapper_DCP1610W $out/lib/cups/filter/brother_lpdwrapper_DCP1610W
    ln -s $out/opt/brother/Printers/DCP1610W/cupswrapper/brother-DCP1610W-cups-en.ppd $out/share/cups/model/
    ln -s $out/opt/brother/Printers/DCP1610W/cupswrapper/brcupsconfig4 $out/lib/cups/filter/brcupsconfig4

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/opt/brother/Printers/DCP1610W/lpd/filter_DCP1610W \
      --replace-fail /opt "$out/opt"

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/DCP1610W/lpd/psconvert2

    patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $out/opt/brother/Printers/DCP1610W/lpd/brprintconflsr3
    patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $out/opt/brother/Printers/DCP1610W/lpd/rawtobr3
    patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $out/opt/brother/Printers/DCP1610W/inf/braddprinter

    wrapProgram $out/opt/brother/Printers/DCP1610W/lpd/psconvert2 \
      --prefix PATH ":" ${
        lib.makeBinPath [
          gnused
          coreutils
          gawk
        ]
      }

    wrapProgram $out/opt/brother/Printers/DCP1610W/lpd/filter_DCP1610W \
      --prefix PATH ":" ${
        lib.makeBinPath [
          ghostscript
          a2ps
          file
          gnused
          coreutils
        ]
      }

    substituteInPlace $out/opt/brother/Printers/DCP1610W/cupswrapper/brother_lpdwrapper_DCP1610W \
      --replace-fail /opt "$out/opt"

    wrapProgram $out/opt/brother/Printers/DCP1610W/cupswrapper/brother_lpdwrapper_DCP1610W \
      --prefix PATH ":" ${
        lib.makeBinPath [
          gnused
          coreutils
          gawk
        ]
      }
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother DCP-1610W printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=nz&lang=en&prod=dcp1610w_eu_as&os=128";
  };
}
