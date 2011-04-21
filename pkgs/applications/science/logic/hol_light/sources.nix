{stdenv, fetchsvn}:

stdenv.mkDerivation rec {
  name = "hol_light_sources-${version}";
  version = "20110417";

  src = fetchsvn {
    url = http://hol-light.googlecode.com/svn/trunk;
    rev = "89";
    sha256 = "a14a7ce61002443daac85583362f9f6f5509b22d441effaeb378e0f2c29185e5";
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
