{
  lib,
  fetchurl,
  pkgsi686Linux,
}:

pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "mfcl2700dnlpr";
  version = "3.2.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf102085/${pname}-${version}.i386.deb";
    sha256 = "170qdzxlqikzvv2wphvfb37m19mn13az4aj88md87ka3rl5knk4m";
  };

  nativeBuildInputs = [
    pkgsi686Linux.dpkg
    pkgsi686Linux.makeWrapper
    pkgsi686Linux.autoPatchelfHook
  ];

  buildInputs = [
    pkgsi686Linux.perl
  ];

  dontUnpack = true;

  installPhase = ''
    dpkg-deb -x $src $out

    dir=$out/opt/brother/Printers/MFCL2700DN

    substituteInPlace $dir/lpd/filter_MFCL2700DN \
      --replace-fail /usr/bin/perl ${pkgsi686Linux.perl}/bin/perl \
      --replace-fail "BR_PRT_PATH =~" "BR_PRT_PATH = \"$dir\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"MFCL2700DN\"; #"

    wrapProgram $dir/lpd/filter_MFCL2700DN \
      --prefix PATH : ${
        lib.makeBinPath [
          pkgsi686Linux.coreutils
          pkgsi686Linux.ghostscript
          pkgsi686Linux.gnugrep
          pkgsi686Linux.gnused
          pkgsi686Linux.which
        ]
      }
  '';

  meta = {
    description = "Brother MFC-L2700DN LPR driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.tv ];
    platforms = [ "i686-linux" ];
  };
}
