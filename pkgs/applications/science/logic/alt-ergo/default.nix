{ fetchurl, stdenv, which, dune, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "alt-ergo-${version}";
  version = "2.3.0";

  src = fetchurl {
    url    = "https://alt-ergo.ocamlpro.com/download_manager.php?target=${name}.tar.gz";
    name   = "${name}.tar.gz";
    sha256 = "1ycr3ff0gacq1aqzs16n6swgfniwpim0m7rvhcam64kj0a80c6bz";
  };

  buildInputs = [ dune which ] ++ (with ocamlPackages; [
    ocaml findlib camlzip lablgtk menhir num ocplib-simplex psmt2-frontend seq zarith
  ]);

  preConfigure = "patchShebangs ./configure";

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "https://alt-ergo.ocamlpro.com/";
    license     = stdenv.lib.licenses.ocamlpro_nc;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
