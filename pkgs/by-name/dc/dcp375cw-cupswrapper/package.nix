{
  lib,
  fetchurl,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation (finalAttrs: {
  pname = "dcp375cw-cupswrapper";
  version = "1.1.3";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf005429/dcp375cwcupswrapper-${finalAttrs.version}-1.i386.deb";
    sha256 = "9a255728b595d2667b2caf9d0d332b677e1a6829a3ec1ed6d4e900a44069cf2d";
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
    for f in $out/opt/brother/Printers/dcp375cw/cupswrapper/cupswrapperdcp375cw; do
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
    ln -s $out/opt/brother/Printers/dcp375cw/cupswrapper/brother_dcp375cw_printer_en.ppd $out/share/cups/model/
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother dcp375cw printer CUPS wrapper driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=dcp375cw_all&os=128";
    maintainers = with lib.maintainers; [ marcovergueira ];
  };
})
