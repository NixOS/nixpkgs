{ stdenv, fetchgit, iasl, flex, bison }:

stdenv.mkDerivation rec {
  name = "cbfstool-${version}";
  version = "git-2015-07-09";

  src = fetchgit {
    url = "http://review.coreboot.org/p/coreboot";
    rev = "5d866213f42fd22aed80abb5a91d74f6d485ac3f";
    sha256 = "148155829jbabsgg1inmcpqmwbg0fgp8a685bzybv9j4ibasi0z2";
  };

  buildInputs = [ iasl flex bison ];

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
    description = "CBFS tool";
    homepage = http://www.coreboot.org;
    license = licenses.gpl2;
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
  };
}

