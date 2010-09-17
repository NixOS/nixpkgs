{stdenv, fetchsvn}:

stdenv.mkDerivation rec {
  name = "hol_light_sources-${version}";
  version = "20100820";

  src = fetchsvn {
    url = http://hol-light.googlecode.com/svn/trunk;
    rev = "57";
    sha256 = "d1372744abca6c9978673850977d3e1577fd8cfd8298826eb713b3681c10cccd";
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
