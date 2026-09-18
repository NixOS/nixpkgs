{
  coreutils,
  dpkg,
  fetchurl,
  gnugrep,
  gnused,
  makeWrapper,
  mfcl8690cdwlpr,
  perl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "mfcl8690cdwcupswrapper";
  version = "1.5.0-3";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103250/mfcl8690cdwcupswrapper-${version}.i386.deb";
    hash = "sha256-CREQRr4nhw1pD+8AfD5p/EHpx3R6vQIO8h6VtnHxXls=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x $src $out

    basedir=${mfcl8690cdwlpr}/opt/brother/Printers/mfcl8690cdw
    dir=$out/opt/brother/Printers/mfcl8690cdw

    substituteInPlace $dir/cupswrapper/brother_lpdwrapper_mfcl8690cdw \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "basedir =~" "basedir = \"$basedir/\"; #" \
      --replace "PRINTER =~" "PRINTER = \"mfcl8690cdw\"; #"

    wrapProgram $dir/cupswrapper/brother_lpdwrapper_mfcl8690cdw \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
        ]
      }

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln $dir/cupswrapper/brother_lpdwrapper_mfcl8690cdw $out/lib/cups/filter
    ln $dir/cupswrapper/brother_mfcl8690cdw_printer_en.ppd $out/share/cups/model
  '';

  meta = {
    description = "Brother MFC-L8690CDW CUPS wrapper driver";
    homepage = "https://www.brother.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nick-linux
    ];
  };
}
