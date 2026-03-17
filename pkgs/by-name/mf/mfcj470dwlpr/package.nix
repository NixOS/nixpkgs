{
  lib,
  stdenv,
  fetchurl,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "mfcj470dw-cupswrapper";
  version = "3.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006843/mfcj470dwlpr-${version}.i386.deb";
    sha256 = "7202dd895d38d50bb767080f2995ed350eed99bc2b7871452c3c915c8eefc30a";
  };

  nativeBuildInputs = [ pkgsi686Linux.makeWrapper ];
  buildInputs = [
    pkgsi686Linux.cups
    pkgsi686Linux.ghostscript
    pkgsi686Linux.dpkg
    pkgsi686Linux.a2ps
  ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x $src $out

    substituteInPlace $out/opt/brother/Printers/mfcj470dw/lpd/filtermfcj470dw \
    --replace /opt "$out/opt" \

    sed -i '/GHOST_SCRIPT=/c\GHOST_SCRIPT=gs' $out/opt/brother/Printers/mfcj470dw/lpd/psconvertij2

    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux.so.2 $out/opt/brother/Printers/mfcj470dw/lpd/brmfcj470dwfilter

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/mfcj470dw/lpd/filtermfcj470dw $out/lib/cups/filter/brother_lpdwrapper_mfcj470dw

    wrapProgram $out/opt/brother/Printers/mfcj470dw/lpd/psconvertij2 \
    --prefix PATH ":" ${
      lib.makeBinPath [
        pkgsi686Linux.gnused
        pkgsi686Linux.coreutils
        pkgsi686Linux.gawk
      ]
    }

    wrapProgram $out/opt/brother/Printers/mfcj470dw/lpd/filtermfcj470dw \
    --prefix PATH ":" ${
      lib.makeBinPath [
        pkgsi686Linux.ghostscript
        pkgsi686Linux.a2ps
        pkgsi686Linux.file
        pkgsi686Linux.gnused
        pkgsi686Linux.coreutils
      ]
    }
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother MFC-J470DW LPR driver";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    downloadPage = "http://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj470dw_us_eu_as&os=128";
    maintainers = [ lib.maintainers.yochai ];
  };
}
