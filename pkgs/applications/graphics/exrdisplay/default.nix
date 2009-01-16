args: with args;

assert fltk.glSupport;
stdenv.mkDerivation {

  name ="openexr_viewers-1.0.1";

  src = fetchurl {
    url =  "http://download.savannah.nongnu.org/releases/openexr/openexr_viewers-1.0.1.tar.gz";
    sha256 = "1w5qbcdp7sw48z1wk2v07f7p14vqqb1m2ncxyxnbkm9f4ab0ymg6";
  };

  inherit fltk mesa;

  configurePhase = "
    # don't know why.. adding these flags it works
    #export CXXFLAGS=`fltk-config --use-gl --cxxflags --ldflags`
    ./configure --prefix=\$out --with-fltk-config=\$fltk/bin/fltk-config";

  buildInputs = [openexr fltk pkgconfig mesa which openexr_ctl];

  meta = { 
      description = "tool to view OpenEXR images";
      homepage = http://openexr.com;
      license = "BSD-like";
  };
}
