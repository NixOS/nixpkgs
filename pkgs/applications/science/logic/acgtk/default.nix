{ stdenv, fetchurl, ocaml, findlib, dypgen, bolt, ansiterminal, camlp4,
  buildBytecode ? true,
  buildNative ? true,
  installExamples ? true,
  installEmacsMode ? true }:

let inherit (stdenv.lib) getVersion versionAtLeast
                         optionals optionalString; in

assert versionAtLeast (getVersion ocaml) "3.07";
assert versionAtLeast (getVersion dypgen) "20080925";
assert versionAtLeast (getVersion bolt) "1.4";

assert buildBytecode || buildNative;

stdenv.mkDerivation {

  name = "acgtk-1.1";

  src = fetchurl {
    url = "http://www.loria.fr/equipes/calligramme/acg/software/acg-1.1-20140905.tar.gz";
    sha256 = "1k1ldqg34bwmgdpmi9gry9czlsk85ycjxnkd25fhlf3mmgg4n9p6";
  };

  buildInputs = [ ocaml findlib dypgen bolt ansiterminal camlp4 ];

  patches = [ ./install-emacs-to-site-lisp.patch
              ./use-nix-ocaml-byteflags.patch ];

  postPatch = stdenv.lib.optionalString (camlp4 != null) ''
    substituteInPlace src/Makefile.master.in \
      --replace "+camlp4" "${camlp4}/lib/ocaml/${getVersion ocaml}/site-lib/camlp4/"
  '';

  # The bytecode executable is dependent on the dynamic library provided by
  # ANSITerminal. We can use the -dllpath flag of ocamlc (analogous to
  # -rpath) to make sure that ocamlrun is able to link the library at
  # runtime and that Nix detects a runtime dependency.
  NIX_OCAML_BYTEFLAGS = "-dllpath ${ansiterminal}/lib/ocaml/${getVersion ocaml}/site-lib/ANSITerminal";

  buildFlags = optionalString buildBytecode "byte"
             + " "
             + optionalString buildNative "opt";

  installTargets = "install"
                 + " " + optionalString installExamples "install-examples"
                 + " " + optionalString installEmacsMode "install-emacs";

  meta = with stdenv.lib; {
    homepage = "http://www.loria.fr/equipes/calligramme/acg";
    description = "A toolkit for developing ACG signatures and lexicon";
    license = licenses.cecill20;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
