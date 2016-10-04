# - coqide compilation can be disabled by setting lablgtk to null;
# - The csdp program used for the Micromega tactic is statically referenced.
#   However, coq can build without csdp by setting it to null.
#   In this case some Micromega tactics will search the user's path for the csdp program and will fail if it is not found.

{stdenv, fetchgit, writeText, pkgconfig, ocaml, findlib, camlp5, ncurses, lablgtk ? null, csdp ? null}:

let
  version = "8.5pre-0c999f02";
  coq-version = "8.5";
  buildIde = lablgtk != null;
  ideFlags = if buildIde then "-lablgtkdir ${lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
  csdpPatch = if csdp != null then ''
    substituteInPlace plugins/micromega/sos.ml --replace "; csdp" "; ${csdp}/bin/csdp"
    substituteInPlace plugins/micromega/coq_micromega.ml --replace "System.is_in_system_path \"csdp\"" "true"
  '' else "";
in

stdenv.mkDerivation {
  name = "coq-${version}";

  inherit coq-version;
  inherit ocaml camlp5;

  src = fetchgit {
    url = git://scm.gforge.inria.fr/coq/coq.git;
    rev = "0c999f02ffcd61fcace0cc2d045056a82992a100";
    sha256 = "08z9z4bv4a8ha1jrn18vxad6d7y7h92ggr00rx8jfvvi290n9344";
  };

  buildInputs = [ pkgconfig ocaml findlib camlp5 ncurses lablgtk ];

  patches = [ ./no-codesign.patch ];

  postPatch = ''
    UNAME=$(type -tp uname)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/uname" "$UNAME"
    substituteInPlace tools/beautify-archive --replace "/bin/rm" "$RM"
    substituteInPlace Makefile.build --replace "ifeq (\$(ARCH),Darwin)" "ifeq (\$(ARCH),Darwinx)"
    ${csdpPatch}
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
    branch = coq-version;
    maintainers = with maintainers; [ roconnor thoughtpolice vbgl ];
    platforms = platforms.unix;
  };
}
