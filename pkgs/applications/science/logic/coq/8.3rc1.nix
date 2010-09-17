# TODO:
# - coqide compilation should be optional or (better) separate;
# - coqide libraries are not installed;

{stdenv, fetchurl, ocaml, camlp5, lablgtk, ncurses}:

stdenv.mkDerivation {
  name = "coq-devel-8.3pre1";

  src = fetchurl {
    url = http://coq.inria.fr/distrib/V8.3-rc1/files/coq-8.3-rc1.tar.gz;
    sha256 = "0r43dqr7nzjfkxlz4963sj18gvjni6x3lhrlgh4l8k0cjspi62sj";
  };

  buildInputs = [ ocaml camlp5 ncurses lablgtk ];

  patches = [ ./coq-8.3-rc1_configure.patch ];

  postPatch = ''
    substituteInPlace scripts/coqmktop.ml --replace \
      "\"-I\"; \"+lablgtk2\"" \
      "\"-I\"; \"${lablgtk}/lib/ocaml/lablgtk2\"; \"-I\"; \"${lablgtk}/lib/ocaml/stublibs\""
  '';

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

  meta = {
    description = "Coq proof assistant (development version)";
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
