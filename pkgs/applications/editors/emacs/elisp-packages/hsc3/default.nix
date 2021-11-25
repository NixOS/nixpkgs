{ lib, stdenv, fetchurl, emacs }:

# this package installs the emacs-mode which
# resides in the hsc3 sources.

let version = "0.15";

in stdenv.mkDerivation {
  pname = "hsc3-mode";
  inherit version;
  src = fetchurl {
    url = "mirror://hackage/hsc3-0.15/hsc3-0.15.tar.gz";
    sha256 = "2f3b15655419cf8ebe25ab1c6ec22993b2589b4ffca7c3a75ce478ca78a0bde6";
  };

  buildInputs = [ emacs ];

  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp "emacs/hsc3.el" "$out/share/emacs/site-lisp"
  '';

  meta = {
    homepage = "http://rd.slavepianos.org/?t=hsc3";
    description = "hsc3 mode package for Emacs";
    platforms = lib.platforms.unix;
  };
}
