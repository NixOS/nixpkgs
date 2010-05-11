# TODO:
# - coqide compilation should be optional or (better) separate;
# - coqide libraries are not installed;

{stdenv, fetchurl, ocaml, camlp5, lablgtk, ncurses}:

stdenv.mkDerivation {
  name = "coq-8.3-beta0-1";

  src = fetchurl {
    url = http://coq.inria.fr/distrib/V8.3-beta0/files/coq-8.3-beta0-1.tar.gz;
    sha256 = "01m1x0gpzfsiybyqanm82ls8q63q0g2d9vvfs99zf4z1nny7vlf1";
  };

  buildInputs = [ ocaml camlp5 ncurses lablgtk ];

  prefixKey = "-prefix ";

  preConfigure = ''
    ARCH=`uname -s`
    CAMLDIR=`type -p ocamlc`
  '';

  configureFlags =
    "-arch $ARCH " +
    "-camldir $CAMLDIR " +
    "-camldir ${ocaml}/bin " +
    "-camlp5dir ${camlp5}/lib/ocaml/camlp5 " +
    "-lablgtkdir ${lablgtk}/lib/ocaml/lablgtk2 " +
    "-opt -coqide opt";

  buildFlags = "world"; # Debug with "world VERBOSE=1";

  patches = [ ./coq-8.3-beta0-1.patch ];

  postPatch = ''
    substituteInPlace scripts/coqmktop.ml --replace \
      "\"-I\"; \"+lablgtk2\"" \
      "\"-I\"; \"${lablgtk}/lib/ocaml/lablgtk2\"; \"-I\"; \"${lablgtk}/lib/ocaml/stublibs\""
  '';

  meta = {
    description = "Coq proof assistant";
    longDescription = ''
      Coq is a formal proof management system.  It provides a formal language
      to write mathematical definitions, executable algorithms and theorems
      together with an environment for semi-interactive development of
      machine-checked proofs.
    '';
    homepage = "http://coq.inria.fr";
    license = "LGPL";
  };
}
