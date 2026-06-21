{
  lib,
  fetchurl,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "dcp9020cdw-cupswrapper";
  version = "1.1.2";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf100443/dcp9020cdwcupswrapper-${finalAttrs.version}-1.i386.deb";
    sha256 = "04yqm1qv9p4hgp1p6mqq4siygl4056s6flv6kqln8mvmcr8zaq1s";
  };

  nativeBuildInputs = [
    pkgsi686Linux.dpkg
    pkgsi686Linux.makeWrapper
  ];
  buildInputs = [
    pkgsi686Linux.cups
    pkgsi686Linux.ghostscript
    pkgsi686Linux.a2ps
    pkgsi686Linux.gawk
  ];
  unpackPhase = "dpkg-deb -x $src $out";

  installPhase = ''
    for f in $out/opt/brother/Printers/dcp9020cdw/cupswrapper/cupswrapperdcp9020cdw; do
      wrapProgram $f --prefix PATH : ${
        lib.makeBinPath [
          pkgsi686Linux.coreutils
          pkgsi686Linux.ghostscript
          pkgsi686Linux.gnugrep
          pkgsi686Linux.gnused
        ]
      }
    done

    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/dcp9020cdw/cupswrapper/brother_dcp9020cdw_printer_en.ppd $out/share/cups/model/
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother dcp9020cdw printer CUPS wrapper driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=dcp9020cdw_eu&os=128";
    maintainers = with lib.maintainers; [ pshirshov ];
  };
})
