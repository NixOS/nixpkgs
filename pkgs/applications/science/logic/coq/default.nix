# - coqide compilation can be disabled by setting lablgtk to null;

{stdenv, fetchurl, ocaml, findlib, camlp5, ncurses, lablgtk ? null}:

let 
  version = "8.3pl4";
  buildIde = lablgtk != null;
  ideFlags = if buildIde then "-lablgtkdir ${lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
  idePatch = if buildIde then ''
    substituteInPlace scripts/coqmktop.ml --replace \
    "\"-I\"; \"+lablgtk2\"" \
    "\"-I\"; \"$(echo "${lablgtk}"/lib/ocaml/*/site-lib/lablgtk2)\"; \"-I\"; \"$(echo "${lablgtk}"/lib/ocaml/*/site-lib/stublibs)\""
  '' else "";
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
      -opt
      -camldir ${ocaml}/bin
      -camlp5dir $(ocamlfind query camlp5)
      ${ideFlags}
    )
  '';

  buildFlags = "world"; # Debug with "world VERBOSE=1";

  patches = [ ./configure.patch ];

  postPatch = ''
    UNAME=$(type -tp uname)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/uname" "$UNAME"
    substituteInPlace tools/beautify-archive --replace "/bin/rm" "$RM"
    ${idePatch}
  '';

  # This post install step is needed to build ssrcoqide from the ssreflect package
  # It could be made optional, but I see little harm in including it in the default
  # distribution -- roconnor
  # This will likely no longer be necessary for coq >= 8.4. -- roconnor
  postInstall = if buildIde then ''
   cp ide/*.cmi ide/ide.*a $out/lib/coq/ide/
  '' else "";

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
