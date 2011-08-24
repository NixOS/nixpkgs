# TODO:
# - coqide compilation should be optional or (better) separate;

{stdenv, fetchurl, ocaml, findlib, camlp5, lablgtk, ncurses}:

let
  version = "8.3pl1";
in

stdenv.mkDerivation {
  name = "coq-${version}";

  src = fetchurl {
    url = "http://coq.inria.fr/V${version}/files/coq-${version}.tar.gz";
    sha256 = "0a791gsbf17y2wi0a376n78pxkhpl0lkzifhy5d3mx3lpn376j9s";
  };

  buildInputs = [ ocaml findlib camlp5 ncurses lablgtk ];

  prefixKey = "-prefix ";

  preConfigure = ''
    configureFlagsArray=(
      -camldir ${ocaml}/bin
      -camlp5dir $(ocamlfind query camlp5)
      -lablgtkdir ${lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -opt -coqide opt
    )
  '';

  buildFlags = "world"; # Debug with "world VERBOSE=1";

  patches = [ ./configure.patch ./coq-8.3-make-3.82-compat.patch ];

  postPatch = ''
    UNAME=$(type -tp uname)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/uname" "$UNAME"
    substituteInPlace tools/beautify-archive --replace "/bin/rm" "$RM"
    substituteInPlace scripts/coqmktop.ml --replace \
      "\"-I\"; \"+lablgtk2\"" \
      "\"-I\"; \"$(echo "${lablgtk}"/lib/ocaml/*/site-lib/lablgtk2)\"; \"-I\"; \"$(echo "${lablgtk}"/lib/ocaml/*/site-lib/stublibs)\""
  '';

  # This post install step is needed to build ssrcoqide from the ssreflect package
  # It could be made optional, but I see little harm in including it in the default
  # distribution -- roconnor
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
