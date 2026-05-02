{
  lib,
  python3,
  callPackage,
  nixosTests,
  config,
}:

# To expose the *srht modules, they have to be a python module so we use `buildPythonModule`
# Then we expose them through all-packages.nix as an application through `toPythonApplication`
# https://github.com/NixOS/nixpkgs/pull/54425#discussion_r250688781
let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      srht = self.callPackage ./core.nix { };

      buildsrht = self.callPackage ./builds.nix { };
      gitsrht = self.callPackage ./git.nix { };
      hubsrht = self.callPackage ./hub.nix { };
      listssrht = self.callPackage ./lists.nix { };
      mansrht = self.callPackage ./man.nix { };
      metasrht = self.callPackage ./meta.nix { };
      pastesrht = self.callPackage ./paste.nix { };
      todosrht = self.callPackage ./todo.nix { };

      scmsrht = self.callPackage ./scm.nix { };
    };
  };
in
with python.pkgs;
lib.recurseIntoAttrs {
  inherit python;
  coresrht = toPythonApplication srht;
  buildsrht = toPythonApplication buildsrht;
  gitsrht = toPythonApplication gitsrht;
  hubsrht = toPythonApplication hubsrht;
  listssrht = toPythonApplication listssrht;
  mansrht = toPythonApplication mansrht;
  metasrht = toPythonApplication metasrht;
  pagessrht = callPackage ./pages.nix { };
  pastesrht = toPythonApplication pastesrht;
  todosrht = toPythonApplication todosrht;
  passthru.tests = {
    nixos-sourcehut = nixosTests.sourcehut;
  };
}
