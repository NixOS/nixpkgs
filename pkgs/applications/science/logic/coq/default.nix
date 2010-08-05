# TODO:
# - coqide compilation should be optional or (better) separate;

{stdenv, fetchurl, ocaml, camlp5, lablgtk, ncurses}:

let
  version = "8.2pl2";
in

stdenv.mkDerivation {
  name = "coq-${version}";

  src = fetchurl {
    url = "http://coq.inria.fr/V${version}/files/coq-${version}.tar.gz";
    sha256 = "0dh2vv3bvz8694dd12kjdkdaq19l1vslvygzif11igshc5bw4rhf";
  };

  buildInputs = [ ocaml camlp5 ncurses lablgtk ];

  prefixKey = "-prefix ";

  configureFlags =
    "-camldir ${ocaml}/bin " +
    "-camlp5dir ${camlp5}/lib/ocaml/camlp5 " +
    "-lablgtkdir ${lablgtk}/lib/ocaml/lablgtk2 " +
    "-opt -coqide opt";

  buildFlags = "world"; # Debug with "world VERBOSE=1";

  patches = [ ./configure.patch.gz ];

  postPatch = ''
    BASH=$(type -tp bash)
    UNAME=$(type -tp uname)
    MV=$(type -tp mv)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/bash" "$BASH" \
                                --replace "/bin/uname" "$UNAME"
    substituteInPlace Makefile --replace "/bin/bash" "$BASH" \
                               --replace "/bin/mv" "$MV" \
                               --replace "/bin/rm" "$RM"
    substituteInPlace Makefile.stage1 --replace "/bin/bash" "$BASH"
    substituteInPlace install.sh --replace "/bin/bash" "$BASH"
    substituteInPlace dev/v8-syntax/check-grammar --replace "/bin/bash" "$BASH"
    substituteInPlace scripts/coqmktop.ml --replace \
      "\"-I\"; \"+lablgtk2\"" \
      "\"-I\"; \"${lablgtk}/lib/ocaml/lablgtk2\"; \"-I\"; \"${lablgtk}/lib/ocaml/stublibs\""
  '';

  postInstall = ''
   cp ide/*.cmi ide/ide.*a $out/lib/coq/ide/
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
