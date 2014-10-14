{ stdenv, fetchurl, emacs }:

# this package installs the emacs-mode which
# resides in the ocaml compiler sources.

let version = "2.0.8";

in stdenv.mkDerivation {
  name = "tuareg-mode-${version}";
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/882/tuareg-2.0.8.tar.bz2;
    sha256 = "128ibdzv5rf33b71d7b3gr9plmfamc28aprl8y0ap0ivc8jaqyga";
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
