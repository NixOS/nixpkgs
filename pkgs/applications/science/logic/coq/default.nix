# - coqide compilation can be disabled by setting buildIde to false
# - The csdp program used for the Micromega tactic is statically referenced.
#   However, coq can build without csdp by setting it to null.
#   In this case some Micromega tactics will search the user's path for the csdp program and will fail if it is not found.
# - The patch-level version can be specified through the `version` argument to
#   the derivation; it defaults to the greatest.

{ stdenv, fetchurl, writeText, pkgconfig
, ocamlPackages, ncurses
, buildIde ? true
, csdp ? null
, version ? "8.6"
}:

let
  sha256 = {
   "8.5pl1"	= "1w2xvm6w16khfn63bp95s25hnkn2ny3w0yqg3lq63gp11aqpbyjb";
   "8.5pl2"	= "0wyywia0darak2zmc5v0ra9rn0b9whwdfiahralm8v5za499s8w3";
   "8.5pl3"	= "0fyk2a4fpifibq8y8jhx1891k55qnsnlygglch64sva0bph94nrh";
   "8.6"	= "1pw1xvy1657l1k69wrb911iqqflzhhp8wwsjvihbgc72r3skqg3f";
  }."${version}";
  coq-version = builtins.substring 0 3 version;
  camlp5 = ocamlPackages.camlp5_transitional;
  ideFlags = if buildIde then "-lablgtkdir ${ocamlPackages.lablgtk}/lib/ocaml/*/site-lib/lablgtk2 -coqide opt" else "";
  csdpPatch = if csdp != null then ''
    substituteInPlace plugins/micromega/sos.ml --replace "; csdp" "; ${csdp}/bin/csdp"
    substituteInPlace plugins/micromega/coq_micromega.ml --replace "System.is_in_system_path \"csdp\"" "true"
  '' else "";
in

stdenv.mkDerivation {
  name = "coq-${version}";

  inherit coq-version;
  inherit camlp5;
  inherit (ocamlPackages) ocaml;
  passthru = {
    inherit (ocamlPackages) findlib;
  };

  src = fetchurl {
    url = "http://coq.inria.fr/distrib/V${version}/files/coq-${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ pkgconfig ocamlPackages.ocaml ocamlPackages.findlib camlp5 ncurses ocamlPackages.lablgtk ];

  postPatch = ''
    UNAME=$(type -tp uname)
    RM=$(type -tp rm)
    substituteInPlace configure --replace "/bin/uname" "$UNAME"
    substituteInPlace tools/beautify-archive --replace "/bin/rm" "$RM"
    substituteInPlace configure.ml --replace '"md5 -q"' '"md5sum"'
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

  buildFlags = "revision coq coqide bin/votour";

  postInstall = ''
    cp bin/votour $out/bin/
  '';

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
