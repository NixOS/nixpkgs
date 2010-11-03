{stdenv, fetchsvn}:

stdenv.mkDerivation rec {
  name = "hol_light_sources-${version}";
  version = "20101029";

  src = fetchsvn {
    url = http://hol-light.googlecode.com/svn/trunk;
    rev = "64";
    sha256 = "91e9cac62586039b13c11af245f85a743e299892b24b39d3c7b2ee13157e87c9";
  };

  buildCommand = ''
    export HOL_DIR="$out/lib/hol_light"
    ensureDir "$HOL_DIR"
    cp -a "${src}" "$HOL_DIR/src"
    cd "$HOL_DIR/src"
    chmod +wX -R .
    patch -p1 < ${./parser_setup.patch}
    substituteInPlace hol.ml --subst-var-by HOL_LIGHT_SRC_DIR "$HOL_DIR/src"
  '';

  meta = {
    description = "Sources for the HOL Light theorem prover";
    homepage = http://www.cl.cam.ac.uk/~jrh13/hol-light/;
    license = "BSD";
  };
}
