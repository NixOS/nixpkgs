# TODO:
# - coqide compilation should be optional or (better) separate;

{stdenv, fetchurl, ocaml, findlib, camlp5, lablgtk, ncurses}:

let
  version = "8.3pl4";
in

stdenv.mkDerivation {
  name = "coq-${version}";

  src = fetchurl {
    url = "http://coq.inria.fr/V${version}/files/coq-${version}.tar.gz";
    sha256 = "17d3lmchmqir1rawnr52g78srg4wkd7clzpzfsivxc4y1zp6rwkr";
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

  patches = [ ./configure.patch ];

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
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
