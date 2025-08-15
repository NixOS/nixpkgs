# Experimental flake interface to Nixpkgs.
# See https://github.com/NixOS/rfcs/pull/49 for details.

# In lieu of performance considerations, the implementation in this file would
# likely have been more concise and expressive. Unfortunately, an implication
# of that would be that in order for some attributes to evaluate, some files
# that are in essence unnecessary for that evaluation would be nonetheless
# evaluated to some extent. So in the trade-off between expressivity and
# performance, performance was chosen and therefore this file is quite literal.
{
  description = "A collection of packages for the Nix package manager";

  outputs =
    { self }:
    let
      lib = import ./lib;

      args = { inherit imports lib self; };

      imports = {
        lib = import ./lib/flake-support.nix args;
        pkgs = import ./pkgs/top-level/flake-support.nix args;
        nixos = import ./nixos/flake-support.nix args;
        doc = import ./doc/flake-support.nix args;
        devShell = import ./flake/dev-shell.nix args;
        formatter = import ./flake/formatter.nix args;
      };
    in
    {
      inherit (imports.lib.outputs) lib;
      inherit (imports.pkgs.outputs) legacyPackages;
      checks = lib.zipAttrsWith (name: lib.foldl lib.mergeAttrs { }) [
        imports.pkgs.outputs.checks
        imports.nixos.outputs.checks
      ];
      htmlDocs = {
        inherit (imports.nixos.outputs.htmlDocs) nixosManual;
        inherit (imports.doc.outputs.htmlDocs) nixpkgsManual;
      };
      inherit (imports.nixos.outputs) nixosModules;
      inherit (imports.devShell.outputs) devShells;
      inherit (imports.formatter.outputs) formatter;
    };
}
