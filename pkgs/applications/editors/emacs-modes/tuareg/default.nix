{ stdenv, fetchzip, emacs }:

# this package installs the emacs-mode which
# resides in the ocaml compiler sources.

let version = "2.0.9";

in stdenv.mkDerivation {
  name = "tuareg-mode-${version}";
  src = fetchzip {
    url = "https://github.com/ocaml/tuareg/releases/download/${version}/tuareg-${version}.tar.gz";
    sha256 = "1rd7ai1wn476zfkkxv2xk72bbzi4d9c17gngd35882q4b5vzp756";
  }; 

  buildInputs = [ emacs ];

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp *.el *.elc  "$out/share/emacs/site-lisp"
  '';

  meta = {
    homepage =  https://github.com/ocaml/tuareg;
    description = "OCaml mode package for Emacs";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
