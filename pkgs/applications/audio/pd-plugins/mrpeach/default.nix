{ lib, stdenv, fetchurl, puredata }:

stdenv.mkDerivation {
  pname = "mrpeach";
  version = "1.1";

  # this was to only usable url I could find:
  # - The main url changes hash: http://pure-data.cvs.sourceforge.net/viewvc/pure-data/externals/mrpeach/?view=tar
  # - There are lot's of places where this SW is available as part of a big pkg: pd-extended, pd-l2ork
  # - It's just 211K

  src = fetchurl {
    url = "http://slackonly.com/pub/korgie/sources/pd_mrpeach-2011.10.21.tar.gz";
    sha256 = "12jqba3jsdrk20ib9wc2wiivki88ypcd4mkzgsri9siywbbz9w8x";
  };

  buildInputs = [ puredata ];

  hardeningDisable = [ "format" ];

  patchPhase = ''
    for D in net osc
    do
      sed -i "s@prefix = /usr/local@prefix = $out@g" $D/Makefile
      for i in ${puredata}/include/pd/*; do
        ln -s $i $D/
      done
    done
  '';

  buildPhase = ''
    for D in net osc
    do
      cd $D
      make
      cd ..
    done
  '';

  installPhase = ''
    for D in net osc
    do
      cd $D
      make install
      cd ..
    done
  '';

  fixupPhase = ''
    mv $out/lib/pd-externals/net $out
    mv $out/lib/pd-externals/osc $out
    rm -rf $out/lib
  '';

  meta = {
    description = "A collection of Pd objectclasses for OSC-messages";
    homepage = "http://puredata.info/downloads/osc";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
