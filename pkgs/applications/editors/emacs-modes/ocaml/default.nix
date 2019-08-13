{ stdenv, emacs, ocaml }:

# this package installs the emacs-mode which
# resides in the ocaml compiler sources.

let version = stdenv.lib.removePrefix "ocaml-" ocaml.name;
in stdenv.mkDerivation {
  pname = "ocaml-mode";
  inherit version;
  inherit (ocaml) prefixKey src;

  # a quick configure to get the Makefile generated. Since
  # we do not build the ocaml itself, we don't really
  # need it to support any features.
  configureFlags = (with stdenv.lib; optional (!(versionAtLeast version "4.02")) "-no-tk") ++
    [ "-no-curses" "-no-pthread" ];

  buildInputs = [ emacs ];
  dontBuild = true;

  installPhase = ''
    cd emacs;
    mkdir -p "$out/share/emacs/site-lisp" "$out/bin"
    EMACSDIR=$out/share/emacs/site-lisp make simple-install install-ocamltags
  '';

  meta = {
    homepage = http://caml.inria.fr;
    description = "OCaml mode package for Emacs";
    platforms = stdenv.lib.platforms.unix;
  };
}
