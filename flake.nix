# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.
{
  description = "A collection of packages for the Nix package manager";

  outputs =
    { self }:
    let
      lib = import ./lib;

      imports = lib.mapAttrs (name: path_: import path_ { inherit imports lib self; }) {
        lib = ./lib/flake-support.nix;
        pkgs = ./pkgs/top-level/flake-support.nix;
        nixos = ./nixos/flake-support.nix;
        doc = ./doc/flake-support.nix;
        devShell = ./flake/dev-shell.nix;
        formatter = ./flake/formatter.nix;
      };

      outputs = lib.foldl lib.recursiveUpdate { } (
        lib.mapAttrsToList (name: lib.getAttr "outputs") imports
      );
    in
    # In lieu of performance considerations, the following attribute set would
    # have been, more simply, the expression for the above `outputs` binding.
    # Unfortunately, an implication of that would be, that in order for any
    # attribute to evaluate, all of the above files would need to be evaluated
    # to some extent. Instead, the following expression is a literal attribute
    # set, where each attribute name is provided literally. And specifically,
    # the expression for the `legacyPackages` attribute value avoids extraneous
    # imports. This sacrifice of expressivity for the benefit of performance
    # was deemed appropriate in light of the ubiquity of `legacyPackages`.
    # The access performance for the rest of the attributes seems less
    # important. Also, some are inter-dependent, so expressivity was preferred.
    {
      inherit (imports.pkgs) legacyPackages;

      inherit (outputs)
        checks
        devShells
        formatter
        htmlDocs
        lib
        nixosModules
        ;
    };
}
