{
  lib,
  stdenv,
  fetchgit,
  bash,
  openmodelica,
  mkOpenModelicaDerivation,
}:
let
  fakegit = import ./fakegit.nix {
    inherit
      lib
      stdenv
      fetchgit
      bash
      ;
  };
in
mkOpenModelicaDerivation {
  pname = "omlibrary";
  omdir = "libraries";
  omtarget = "omlibrary-all";
  omdeps = [ openmodelica.omcompiler ];

  postPatch = ''
    patchShebangs --build libraries
    cp -fv ${fakegit}/bin/checkout-git.sh libraries/checkout-git.sh

    # The EMOTH library is broken in OpenModelica 1.17.0
    # Let's remove it from targets.
    sed -i -e '/^OTHER_LIBS=/ s/EMOTH //' libraries/Makefile.libs
  '';

  meta = with lib; {
    description = "Collection of Modelica libraries to use with OpenModelica,
including Modelica Standard Library";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
  };
}
