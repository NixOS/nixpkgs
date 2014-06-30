{ stdenv, fetchurl, emacs }:

# this package installs the emacs-mode which
# resides in the ocaml compiler sources.

let version = "2.0.6";

in stdenv.mkDerivation {
  name = "tuareg-mode-${version}";
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/882/tuareg-2.0.6.tar.gz;
    sha256 = "ea79ac24623b82ab8047345f8504abca557a537e639d16ce1ac3e5b27f5b1189";
  }; 

  buildInputs = [ emacs ];

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp *.el *.elc  "$out/share/emacs/site-lisp"
  '';

  meta = {
    homepage = http://caml.inria.fr;
    description = "OCaml mode package for Emacs";
    platforms = stdenv.lib.platforms.unix;
  };
}
