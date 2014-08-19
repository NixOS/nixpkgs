# - coqide compilation can be disabled by setting lablgtk to null;

{stdenv, fetchurl, pkgconfig, ocaml, findlib, camlp5, ncurses, lablgtk ? null}:

let 
  version = "8.4pl4";
  buildIde = lablgtk != null;
  ideFlags = if buildIde then "-lablgtkdir ${lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
  idePath = if buildIde then ''
    CAML_LD_LIBRARY_PATH=${lablgtk}/lib/ocaml/3.12.1/site-lib/stublibs
  '' else "";
in

stdenv.mkDerivation {
  name = "coq-${version}";

  src = fetchurl {
    url = "http://coq.inria.fr/distrib/V${version}/files/coq-${version}.tar.gz";
    sha256 = "00bzf4kfbd0g279jrr8ynzvb9wqcly3wi577bkrxivhrg2msxhq6";
  };

  buildInputs = [ pkgconfig ocaml findlib camlp5 ncurses lablgtk ];

  patches = [ ./configure.patch ];

  postPatch = ''
    UNAME=$(type -tp uname)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/uname" "$UNAME"
    substituteInPlace tools/beautify-archive --replace "/bin/rm" "$RM"
  '';

  preConfigure = ''
    buildFlagsArray=(${idePath})
    configureFlagsArray=(
      -opt
      -camldir ${ocaml}/bin
      -camlp5dir $(ocamlfind query camlp5)
      ${ideFlags}
    )
  '';

  prefixKey = "-prefix ";

  buildFlags = "revision coq coqide";

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
    maintainers = with stdenv.lib.maintainers; [ roconnor thoughtpolice ];
    platforms = stdenv.lib.platforms.unix;
  };
}
