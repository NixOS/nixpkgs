{ python3
, callPackage
, recurseIntoAttrs
, nixosTests
, config
}:

# To expose the *srht modules, they have to be a python module so we use `buildPythonModule`
# Then we expose them through all-packages.nix as an application through `toPythonApplication`
# https://github.com/NixOS/nixpkgs/pull/54425#discussion_r250688781
let
  fetchNodeModules = callPackage ./fetchNodeModules.nix { };

  python = python3.override {
    packageOverrides = self: super: {
      srht = self.callPackage ./core.nix { inherit fetchNodeModules; };

      buildsrht = self.callPackage ./builds.nix { };
      gitsrht = self.callPackage ./git.nix { };
      hgsrht = self.callPackage ./hg.nix { };
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
with python.pkgs; recurseIntoAttrs ({
  inherit python;
  coresrht = toPythonApplication srht;
  buildsrht = toPythonApplication buildsrht;
  gitsrht = toPythonApplication gitsrht;
  hgsrht = toPythonApplication hgsrht;
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
} // lib.optionalAttrs config.allowAliases {
  # Added 2022-10-29
  dispatchsrht = throw "dispatch is deprecated. See https://sourcehut.org/blog/2022-08-01-dispatch-deprecation-plans/ for more information.";
})
