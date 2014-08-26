# - coqide compilation can be disabled by setting lablgtk to null;

{stdenv, fetchgit, pkgconfig, ocaml, findlib, camlp5, ncurses, lablgtk ? null}:

let 
  version = "8.5pre-c70d5b2";
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
    rev = "c70d5b27ad5872c74e20b6c997383fb4462a68dc";
    sha256 = "02wks2aivgjcf4h3ss9rn683vyawz8gl8rbysdq7awxh062316l2";
  };

  buildInputs = [ pkgconfig ocaml findlib camlp5 ncurses lablgtk ];

  patches = [ ./no-codesign.patch ];

  postPatch = ''
    UNAME=$(type -tp uname)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/uname" "$UNAME"
    substituteInPlace tools/beautify-archive --replace "/bin/rm" "$RM"
    substituteInPlace Makefile.build --replace "ifeq (\$(ARCH),Darwin)" "ifeq (\$(ARCH),Darwinx)"
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
