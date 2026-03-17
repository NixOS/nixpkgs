{
  lib,
  fetchurl,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "dcp375cw-lpr";
  version = "1.1.3";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf005427/dcp375cwlpr-${finalAttrs.version}-1.i386.deb";
    sha256 = "6daf0144b5802ea8da394ca14db0e6f0200d4049545649283791f899b7f7bd26";
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
    substituteInPlace $out/opt/brother/Printers/dcp375cw/lpd/filterdcp375cw \
      --replace-fail /opt "$out/opt"

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/dcp375cw/lpd/filterdcp375cw $out/lib/cups/filter/brlpdwrapperdcp375cw

    wrapProgram $out/opt/brother/Printers/dcp375cw/lpd/filterdcp375cw \
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
    description = "Brother dcp375cw printer driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=dcp375cw_all&os=128";
    maintainers = with lib.maintainers; [ marcovergueira ];
  };
})
