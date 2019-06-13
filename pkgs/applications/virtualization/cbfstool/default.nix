{ stdenv, fetchurl, iasl, flex, bison }:

stdenv.mkDerivation rec {
  name = "cbfstool-${version}";
  version = "4.9";

  src = fetchurl {
    url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
    sha256 = "0xkai65d3z9fivwscbkm7ndcw2p9g794xz8fwdv979w77n5qsdij";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ iasl ];

  buildPhase = ''
    export LEX=${flex}/bin/flex
    make -C util/cbfstool
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp util/cbfstool/cbfstool $out/bin
    cp util/cbfstool/fmaptool $out/bin
    cp util/cbfstool/rmodtool $out/bin
    '';

  meta = with stdenv.lib; {
    description = "Management utility for CBFS formatted ROM images";
    homepage = https://www.coreboot.org;
    license = licenses.gpl2;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}

