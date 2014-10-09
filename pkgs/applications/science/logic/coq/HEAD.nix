# - coqide compilation can be disabled by setting lablgtk to null;

{stdenv, fetchgit, writeText, pkgconfig, ocaml, findlib, camlp5, ncurses, lablgtk ? null}:

let
  version = "8.5pre-2313bde0";
  coq-version = "8.5";
  buildIde = lablgtk != null;
  ideFlags = if buildIde then "-lablgtkdir ${lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
in

stdenv.mkDerivation {
  name = "coq-${version}";

  inherit coq-version;
  inherit ocaml camlp5;

  src = fetchgit {
    url = git://scm.gforge.inria.fr/coq/coq.git;
    rev = "2313bde0116a5916912bebbaca77d291f7b2760a";
    sha256 = "116b8060a47a7b2d0cac72d86f7e320bec99b6d450614d1e6b92ff919619c509";
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

  setupHook = writeText "setupHook.sh" ''
    addCoqPath () {
      if test -d "''$1/lib/coq/${coq-version}/user-contrib"; then
        export COQPATH="''${COQPATH}''${COQPATH:+:}''$1/lib/coq/${coq-version}/user-contrib/"
      fi
    }

    envHooks=(''${envHooks[@]} addCoqPath)
  '';

  preConfigure = ''
    configureFlagsArray=(
      -opt
      ${ideFlags}
    )
  '';

  prefixKey = "-prefix ";

  buildFlags = "revision coq coqide";

  meta = with stdenv.lib; {
    description = "Coq proof assistant";
    longDescription = ''
      Coq is a formal proof management system.  It provides a formal language
      to write mathematical definitions, executable algorithms and theorems
      together with an environment for semi-interactive development of
      machine-checked proofs.
    '';
    homepage = "http://coq.inria.fr";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ roconnor thoughtpolice vbgl ];
    platforms = platforms.unix;
  };
}
