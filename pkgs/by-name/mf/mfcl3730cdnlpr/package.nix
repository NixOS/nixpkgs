{
  coreutils,
  dpkg,
  fetchurl,
  ghostscript,
  gnugrep,
  gnused,
  lib,
  makeWrapper,
  perl,
  pkgsi686Linux,
  which,
}:

pkgsi686Linux.stdenv.mkDerivation rec {
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
      dir="$out/opt/brother/Printers/${model}"
      substituteInPlace $dir/lpd/filter_${model} \
        --replace /usr/bin/perl ${perl}/bin/perl \
        --replace "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
        --replace "PRINTER =~" "PRINTER = \"${model}\"; #"
      wrapProgram $dir/lpd/filter_${model} \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            ghostscript
            gnugrep
            gnused
            which
          ]
        }
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $dir/lpd/br${model}filter
  '';

  meta = with lib; {
    description = "Brother MFC-L3730CDN LPR printer driver";
    homepage = "https://www.brother.com/";
    license = licenses.unfree;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ SchweGELBin ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
