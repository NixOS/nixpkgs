{
  coreutils,
  dpkg,
  fetchurl,
  gnugrep,
  gnused,
  lib,
  makeWrapper,
  mfcl3730cdnlpr,
  perl,
  stdenv,
}:

stdenv.mkDerivation rec {
  model = "mfcl3730cdn";
  pname = "${model}lpr";
  version = "1.0.2-0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103931/${model}pdrv-${version}.i386.deb";
    sha256 = "1b3pyfl2w4aa9mpi56szi0mhd0qbw7fgmspbrmkywprgwcvvgdjm";
  };

  unpackPhase = "dpkg-deb -x $src $out";

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    basedir="${mfcl3730cdnlpr}/opt/brother/Printers/${model}"
    dir="$out/opt/brother/Printers/${model}"
    substituteInPlace $dir/cupswrapper/brother_lpdwrapper_${model} \
      --replace /usr/bin/perl ${perl}/bin/perl \
      --replace "basedir =~" "basedir = \"$basedir\"; #" \
      --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
    wrapProgram $dir/cupswrapper/brother_lpdwrapper_${model} \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
        ]
      }
    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model
    ln $dir/cupswrapper/brother_lpdwrapper_${model} $out/lib/cups/filter
    ln $dir/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model
  '';

  meta = with lib; {
    description = "Brother MFC-L3730CDN CUPS wrapper driver";
    homepage = "https://www.brother.com/";
    license = licenses.gpl2Plus;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ SchweGELBin ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
