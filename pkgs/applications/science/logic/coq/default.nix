# TODO:
# - coqide compilation should be optional or (better) separate;

{stdenv, fetchurl, ocaml, camlp5, lablgtk, ncurses}:

let

  pname = "coq";
  version = "8.2pl1";
  name = "${pname}-${version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://coq.inria.fr/V${version}/files/${name}.tar.gz";
    sha256 = "7c15acfd369111e51d937cce632d22fc77a6718a5ac9f2dd2dcbdfab4256ae0c";
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
