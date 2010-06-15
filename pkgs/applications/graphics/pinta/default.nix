{stdenv, fetchurl, mono, gtksharp, pkgconfig}:

stdenv.mkDerivation {
  name = "pinta-0.3";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://download.github.com/jpobst-Pinta-0.3-0-g94f6e82.tar.gz;
    sha256 = "0qvpz9602igjmv8ba6vc4kg9jj3yyw0frl7wgz62hdxiizdfhm2f";
  };

  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;

  buildInputs = [mono gtksharp pkgconfig];

  inherit gtksharp;
}
