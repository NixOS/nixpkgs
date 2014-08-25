# - coqide compilation can be disabled by setting lablgtk to null;

{stdenv, fetchgit, pkgconfig, ocaml, findlib, camlp5, ncurses, lablgtk ? null}:

let 
  version = "8.5pre-8bc01590";
  buildIde = lablgtk != null;
  ideFlags = if buildIde then "-lablgtkdir ${lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
  idePath = if buildIde then ''
    CAML_LD_LIBRARY_PATH=${lablgtk}/lib/ocaml/3.12.1/site-lib/stublibs
  '' else "";
in

stdenv.mkDerivation {
  name = "coq-${version}";

  src = fetchgit {
    url = git://scm.gforge.inria.fr/coq/coq.git;
    rev = "8bc0159095cb0230a50c55a1611c8b77134a6060";
    sha256 = "1cp4hbk9jw78y03vwz099yvixax161h60hsbyvwiwz2z5czjxzcv";
  };

  buildInputs = [ pkgconfig ocaml findlib camlp5 ncurses lablgtk ];

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
