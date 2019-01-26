{ stdenv, fetchgit, iasl, flex, bison }:

stdenv.mkDerivation rec {
  name = "cbfstool-${version}";
  version = "4.7";

  src = fetchgit {
    url = "http://review.coreboot.org/p/coreboot";
    rev = "refs/tags/${version}";
    sha256 = "02k63013vf7wgsilslj68fs1x81clvqpn91dydaqhv5aymh73zpi";
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

