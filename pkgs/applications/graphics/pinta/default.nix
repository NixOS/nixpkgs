{stdenv, fetchgit, mono, gtksharp, pkgconfig}:

stdenv.mkDerivation {
  name = "pinta-20100617";

  builder = ./builder.sh;

  src = fetchgit {
    url = http://github.com/jpobst/Pinta.git;
    tag = "0.3";
    sha256 = "0qvpz9602igjmv8ba6vc4kg9jj3yyw0frl7wgz62hdxiizdfhm2f";
  };

  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;

  makePhase = ''
    HOME=`pwd`/tmphome
    mkdir -p $HOME
    xbuild Pinta.Core/Pinta.Core.csproj /v:diag
  '';

  buildInputs = [mono gtksharp pkgconfig];

  inherit gtksharp;
}
