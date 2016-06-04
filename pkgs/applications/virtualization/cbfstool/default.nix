{ stdenv, fetchgit, iasl, flex, bison }:

stdenv.mkDerivation rec {
  name = "cbfstool-${version}";
  version = "git-2015-07-09";

  src = fetchgit {
    url = "http://review.coreboot.org/p/coreboot";
    rev = "5d866213f42fd22aed80abb5a91d74f6d485ac3f";
    sha256 = "1fki5670pmz1wb0yg0a0hb5cap78mgbvdhj8m2xly2kndwicg40p";
  };

  buildInputs = [ iasl flex bison ];

  hardeningDisable = [ "fortify" ];

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

