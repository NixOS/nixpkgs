# - coqide compilation can be disabled by setting lablgtk to null;
# - The csdp program used for the Micromega tactic is statically referenced.
#   However, coq can build without csdp by setting it to null.
#   In this case some Micromega tactics will search the user's path for the csdp program and will fail if it is not found.

{stdenv, fetchurl, pkgconfig, writeText, ocaml, findlib, camlp5, ncurses, lablgtk ? null, csdp ? null}:

let
  version = "8.4pl6";
  coq-version = "8.4";
  buildIde = lablgtk != null;
  ideFlags = if buildIde then "-lablgtkdir ${lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
  csdpPatch = if csdp != null then ''
    substituteInPlace plugins/micromega/sos.ml --replace "; csdp" "; ${csdp}/bin/csdp"
    substituteInPlace plugins/micromega/coq_micromega.ml --replace "System.is_in_system_path \"csdp\"" "true"
  '' else "";

self =
stdenv.mkDerivation {
  name = "coq-${version}";

  inherit coq-version;
  inherit ocaml camlp5;

  src = fetchurl {
    url = "http://coq.inria.fr/distrib/V${version}/files/coq-${version}.tar.gz";
    sha256 = "1mpbj4yf36kpjg2v2sln12i8dzqn8rag6fd07hslj2lpm4qs4h55";
  };

  buildInputs = [ pkgconfig ocaml findlib camlp5 ncurses lablgtk ];

  patches = [ ./configure.patch ];

  postPatch = ''
    UNAME=$(type -tp uname)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/uname" "$UNAME"
    substituteInPlace tools/beautify-archive --replace "/bin/rm" "$RM"
    ${csdpPatch}
  '';

  preConfigure = ''
    configureFlagsArray=(
      -opt
      -camldir ${ocaml}/bin
      -camlp5dir $(ocamlfind query camlp5)
      ${ideFlags}
    )
  '';

  prefixKey = "-prefix ";

  buildFlags = "revision coq coqide";

  setupHook = writeText "setupHook.sh" ''
    addCoqPath () {
      if test -d "''$1/lib/coq/${coq-version}/user-contrib"; then
        export COQPATH="''${COQPATH}''${COQPATH:+:}''$1/lib/coq/${coq-version}/user-contrib/"
      fi
    }

    envHooks=(''${envHooks[@]} addCoqPath)
  '';

  passthru = {
    inherit findlib;
    emacsBufferSetup = pkgs: ''
      ; Propagate coq paths to children
      (inherit-local-permanent coq-prog-name "${self}/bin/coqtop")
      (inherit-local-permanent coq-dependency-analyzer "${self}/bin/coqdep")
      (inherit-local-permanent coq-compiler "${self}/bin/coqc")
      ; If the coq-library path was already set, re-set it based on our current coq
      (when (fboundp 'get-coq-library-directory)
        (inherit-local-permanent coq-library-directory (get-coq-library-directory))
        (coq-prog-args))
      (mapc (lambda (arg)
        (when (file-directory-p (concat arg "/lib/coq/${coq-version}/user-contrib"))
          (setenv "COQPATH" (concat (getenv "COQPATH") ":" arg "/lib/coq/${coq-version}/user-contrib")))) '(${stdenv.lib.concatStringsSep " " (map (pkg: "\"${pkg}\"") pkgs)}))
    '';
  };

  meta = with stdenv.lib; {
    description = "Formal proof management system";
    longDescription = ''
      Coq is a formal proof management system.  It provides a formal language
      to write mathematical definitions, executable algorithms and theorems
      together with an environment for semi-interactive development of
      machine-checked proofs.
    '';
    homepage = http://coq.inria.fr;
    license = licenses.lgpl21;
    branch = coq-version;
    maintainers = with maintainers; [ roconnor thoughtpolice vbgl ];
    platforms = platforms.unix;
  };
}; in self
