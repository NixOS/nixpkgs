{stdenv, fetchgit, mono, gtksharp, pkgconfig, automake, autoconf}:

stdenv.mkDerivation {
  name = "pinta-20100617";

  builder = ./builder.sh;

  src = fetchgit {
    url = http://github.com/jpobst/Pinta.git;
    rev = "c8ce06fc14a42083749b6400ed57d3883820d368";
    sha256 = "9df96b69b08567045e9100e228047d7711db28705bd2badc0afc316e63c15505";
  };

  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;

  configurePhase = ''
    sh ./autogen.sh --prefix=$out
  '';

  makePhase = ''
    HOME=`pwd`/tmphome
    mkdir -p $HOME
    xbuild Pinta.Core/Pinta.Core.csproj /v:diag
  '';

  buildInputs = [mono gtksharp pkgconfig automake autoconf];

  inherit gtksharp;
}
