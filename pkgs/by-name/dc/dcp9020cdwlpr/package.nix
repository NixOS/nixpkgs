{
  lib,
  fetchurl,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "dcp9020cdw-lpr";
  version = "1.1.2";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf100441/dcp9020cdwlpr-${finalAttrs.version}-1.i386.deb";
    sha256 = "1z6nma489s0a0b0a8wyg38yxanz4k99dg29fyjs4jlprsvmwk56y";
  };

  nativeBuildInputs = [
    pkgsi686Linux.dpkg
    pkgsi686Linux.makeWrapper
    pkgsi686Linux.autoPatchelfHook
  ];

  buildInputs = [
    pkgsi686Linux.cups
    pkgsi686Linux.ghostscript
    pkgsi686Linux.a2ps
    pkgsi686Linux.gawk
  ];

  unpackPhase = "dpkg-deb -x $src $out";

  installPhase = ''
    substituteInPlace $out/opt/brother/Printers/dcp9020cdw/lpd/filterdcp9020cdw \
    --replace-fail /opt "$out/opt"

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/dcp9020cdw/lpd/filterdcp9020cdw $out/lib/cups/filter/brother_lpdwrapper_dcp9020cdw

    wrapProgram $out/opt/brother/Printers/dcp9020cdw/lpd/filterdcp9020cdw \
      --prefix PATH ":" ${
        lib.makeBinPath [
          pkgsi686Linux.gawk
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
    description = "Brother dcp9020cdw printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=dcp9020cdw_eu&os=128";
    maintainers = with lib.maintainers; [ pshirshov ];
  };
})
