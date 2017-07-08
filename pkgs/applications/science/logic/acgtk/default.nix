{ stdenv, fetchurl, ocamlPackages,
  buildBytecode ? true,
  buildNative ? true,
  installExamples ? true,
  installEmacsMode ? true }:

let inherit (stdenv.lib) versionAtLeast
                         optionals optionalString; in

let inherit (ocamlPackages) ocaml camlp4; in

assert buildBytecode || buildNative;

stdenv.mkDerivation {

  name = "acgtk-1.3.1";

  src = fetchurl {
    url = http://calligramme.loria.fr/acg/software/acg-1.3.1-20170303.tar.gz;
    sha256 = "1hhrf6bx2x2wbv5ldn4fnxhpr9lyrj3zh1vcnx8wf8f06ih4rzfq";
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib camlp4 ansiterminal biniou bolt ocaml_cairo2 dypgen easy-format ocf yojson
  ];

  patches = [ ./install-emacs-to-site-lisp.patch
              ./use-nix-ocaml-byteflags.patch ];

  postPatch = stdenv.lib.optionalString (camlp4 != null) ''
    substituteInPlace src/Makefile.master.in \
      --replace "+camlp4" "${camlp4}/lib/ocaml/${ocaml.version}/site-lib/camlp4/"
  '';

  # The bytecode executable is dependent on the dynamic library provided by
  # ANSITerminal. We can use the -dllpath flag of ocamlc (analogous to
  # -rpath) to make sure that ocamlrun is able to link the library at
  # runtime and that Nix detects a runtime dependency.
  NIX_OCAML_BYTEFLAGS = "-dllpath ${ocamlPackages.ansiterminal}/lib/ocaml/${ocaml.version}/site-lib/ANSITerminal";

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
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}
