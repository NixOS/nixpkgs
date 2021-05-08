{lib, stdenv, fetchgit, bash, pkgconfig, jre, libuuid,
openmodelica, mkOpenModelicaDerivation }:
let
  fakegit = import ./fakegit.nix { inherit lib stdenv fetchgit bash; };
in
mkOpenModelicaDerivation {
  pname = "omlibrary";
  omdir = "libraries";
  omtarget = "omlibrary-core";
  omdeps = [openmodelica.omcompiler];

  nativeBuildInputs = [];

  buildInputs = [];

  patchPhase = ''
    patchShebangs --build libraries
    cp -fv ${fakegit}/bin/checkout-git.sh libraries/checkout-git.sh
  '';
}
