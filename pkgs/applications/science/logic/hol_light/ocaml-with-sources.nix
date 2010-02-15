{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ocaml-with-sources-3.09.3";
  src = fetchurl {
    url = http://caml.inria.fr/pub/distrib/ocaml-3.09/ocaml-3.09.3.tar.bz2;
    sha256 = "607842b4f4917a759f19541a421370a834f5b948855ca54cef40d22b19a0934f";
  };

  configureScript = ./configure-3.09.3;

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    ensureDir $out/src; cd $out/src
    tar -xjf $src
    mv ocaml-* ocaml
    cd ocaml
    CAT=$(type -tp cat)
    sed -e "s@/bin/cat@$CAT@" -i config/auto-aux/sharpbang
    $configureScript -no-tk -no-curses -prefix $out
    make opt.opt
    make install
  '';

  meta = {
    description = "ocaml compiler with compiled sources retained.";
    longDescription = ''
      TODO
    '';
    homepage = http://caml.inria.fr/;
    license = "LGP with linking exceptions";
  };
}
