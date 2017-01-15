# - coqide compilation can be disabled by setting buildIde to false;
# - The csdp program used for the Micromega tactic is statically referenced.
#   However, coq can build without csdp by setting it to null.
#   In this case some Micromega tactics will search the user's path for the csdp program and will fail if it is not found.

{stdenv, fetchgit, writeText, pkgconfig, ocamlPackages_4_02, ncurses, buildIde ? true, csdp ? null}:

let
  version = "2017-01-22";
  coq-version = "8.6";
  ideFlags = if buildIde then "-lablgtkdir ${ocamlPackages_4_02.lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
  csdpPatch = if csdp != null then ''
    substituteInPlace plugins/micromega/sos.ml --replace "; csdp" "; ${csdp}/bin/csdp"
    substituteInPlace plugins/micromega/coq_micromega.ml --replace "System.is_in_system_path \"csdp\"" "true"
  '' else "";
  ocaml = ocamlPackages_4_02.ocaml;
  findlib = ocamlPackages_4_02.findlib;
  lablgtk = ocamlPackages_4_02.lablgtk;
  camlp5 = ocamlPackages_4_02.camlp5_transitional;
in

stdenv.mkDerivation {
  name = "coq-unstable-${version}";

  inherit coq-version;
  inherit ocaml camlp5 findlib;

  src = fetchgit {
    url = git://scm.gforge.inria.fr/coq/coq.git;
    rev = "d6bcc6ebe4f65d0555414851f7e4fb6fa1fb22a4";
    sha256 = "1k5wkwlis836iwy1s8hfjw9gwdk8vp405hp09s6d44ijb2ihr356";
  };

  buildInputs = [ pkgconfig ocaml findlib camlp5 ncurses lablgtk ];

  postPatch = ''
    UNAME=$(type -tp uname)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/uname" "$UNAME"
    substituteInPlace tools/beautify-archive --replace "/bin/rm" "$RM"
    substituteInPlace configure.ml --replace "\"Darwin\"; \"FreeBSD\"; \"OpenBSD\"" "\"Darwinx\"; \"FreeBSD\"; \"OpenBSD\""
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
