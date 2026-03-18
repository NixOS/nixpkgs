{
  lib,
  fetchurl,
  pkgsi686Linux,
}:

let
  version = "3.2.0-1";
  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101912/hll2340dlpr-${version}.i386.deb";
    sha256 = "c0ae98b49b462cd8fbef445550f2177ce9d8bf627c904e182daa8cbaf8781e50";
  };

  cupsdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf101913/hll2340dcupswrapper-${version}.i386.deb";
    sha256 = "8aa24a6a825e3a4d5b51778cb46fe63032ec5a731ace22f9ef2b0ffcc2033cc9";
  };

in
pkgsi686Linux.stdenv.mkDerivation {
  pname = "cups-brother-hll2340dw";
  inherit version;

  nativeBuildInputs = [
    pkgsi686Linux.makeWrapper
    pkgsi686Linux.dpkg
    pkgsi686Linux.autoPatchelfHook
  ];

  buildInputs = [
    pkgsi686Linux.cups
    pkgsi686Linux.ghostscript
    pkgsi686Linux.a2ps
    pkgsi686Linux.perl
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x ${cupsdeb} $out
    dpkg-deb -x ${lprdeb} $out

    substituteInPlace $out/opt/brother/Printers/HLL2340D/lpd/filter_HLL2340D \
      --replace-fail /usr/bin/perl ${pkgsi686Linux.perl}/bin/perl \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$out/opt/brother/Printers/HLL2340D/\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"HLL2340D\"; #"

    for f in \
      $out/opt/brother/Printers/HLL2340D/cupswrapper/brother_lpdwrapper_HLL2340D \
      $out/opt/brother/Printers/HLL2340D/cupswrapper/paperconfigml1 \
    ; do
      wrapProgram $f \
        --prefix PATH : ${
          lib.makeBinPath [
            pkgsi686Linux.coreutils
            pkgsi686Linux.ghostscript
            pkgsi686Linux.gnugrep
            pkgsi686Linux.gnused
          ]
        }
    done

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/HLL2340D/lpd/filter_HLL2340D $out/lib/cups/filter/brother_lpdwrapper_HLL2340D

    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/HLL2340D/cupswrapper/brother-HLL2340D-cups-en.ppd $out/share/cups/model/

    wrapProgram $out/opt/brother/Printers/HLL2340D/lpd/filter_HLL2340D \
      --prefix PATH ":" ${
        lib.makeBinPath [
          pkgsi686Linux.ghostscript
          pkgsi686Linux.a2ps
          pkgsi686Linux.file
          pkgsi686Linux.gnused
          pkgsi686Linux.gnugrep
          pkgsi686Linux.coreutils
          pkgsi686Linux.which
        ]
      }
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother hl-l2340dw printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=es&prod=hll2340dw_us_eu_as&os=128&flang=English";
    maintainers = [ lib.maintainers.qknight ];
  };
}
