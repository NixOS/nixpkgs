{
  lib,
  pkgsi686Linux,
  fetchurl,
}:

let
  version = "3.0.1-1";
  cupsdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101546/hl1210wcupswrapper-${version}.i386.deb";
    sha256 = "0395mnw6c7qpjgjch9in5q9p2fjdqvz9bwfwp6q1hzhs08ryk7w0";
  };
  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101547/hl1210wlpr-${version}.i386.deb";
    sha256 = "1sl3g2cd4a2gygryrr27ax3qaa65cbirz3kzskd8afkwqpmjyv7j";
  };
in
pkgsi686Linux.stdenv.mkDerivation {
  pname = "cups-brother-hl1210W";
  inherit version;

  srcs = [
    lprdeb
    cupsdeb
  ];

  nativeBuildInputs = [
    pkgsi686Linux.makeWrapper
    pkgsi686Linux.autoPatchelfHook
    pkgsi686Linux.dpkg
  ];

  buildInputs = [
    pkgsi686Linux.cups
    pkgsi686Linux.ghostscript
    pkgsi686Linux.a2ps
  ];

  dontUnpack = true;

  installPhase = ''
    # install lpr
    dpkg-deb -x ${lprdeb} $out

    substituteInPlace $out/opt/brother/Printers/HL1210W/lpd/filter_HL1210W \
      --replace /opt "$out/opt"

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/HL1210W/lpd/psconvert2

    wrapProgram $out/opt/brother/Printers/HL1210W/lpd/psconvert2 \
      --prefix PATH ":" ${
        lib.makeBinPath [
          pkgsi686Linux.gnused
          pkgsi686Linux.coreutils
          pkgsi686Linux.gawk
        ]
      }
    wrapProgram $out/opt/brother/Printers/HL1210W/lpd/filter_HL1210W \
      --prefix PATH ":" ${
        lib.makeBinPath [
          pkgsi686Linux.ghostscript
          pkgsi686Linux.a2ps
          pkgsi686Linux.file
          pkgsi686Linux.gnused
          pkgsi686Linux.coreutils
        ]
      }

    # install cups
    dpkg-deb -x ${cupsdeb} $out

    substituteInPlace $out/opt/brother/Printers/HL1210W/cupswrapper/brother_lpdwrapper_HL1210W --replace /opt "$out/opt"

    mkdir -p $out/lib/cups/filter $out/share/cups/model
    ln -s $out/opt/brother/Printers/HL1210W/cupswrapper/brother_lpdwrapper_HL1210W $out/lib/cups/filter/brother_lpdwrapper_HL1210W
    ln -s $out/opt/brother/Printers/HL1210W/cupswrapper/brother-HL1210W-cups-en.ppd $out/share/cups/model/
    # cp brcupsconfig4 $out/opt/brother/Printers/HL1110/cupswrapper/
    ln -s $out/opt/brother/Printers/HL1210W/cupswrapper/brcupsconfig4 $out/lib/cups/filter/brcupsconfig4

    wrapProgram $out/opt/brother/Printers/HL1210W/cupswrapper/brother_lpdwrapper_HL1210W \
      --prefix PATH ":" ${
        lib.makeBinPath [
          pkgsi686Linux.gnused
          pkgsi686Linux.coreutils
          pkgsi686Linux.gawk
        ]
      }
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother HL1210W printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=nz&lang=en&prod=hl1210w_eu_as&os=128";
  };
}
