/*
  The Nixpkgs flake interface. Flakes are experimental—see
  https://github.com/NixOS/rfcs/pull/49 for details.

  This file and the other `flake-support.nix` files involved compose together
  to create the flake interface. This composition logic could be implemented
  in various different ways. For example, the logic could be more abstract,
  making use of `lib.recursiveUpdate` and overall fewer lines of code in this
  file. Another example is usage of the Nixpkgs module system, benefiting from
  its option value merging feature and arguably some type checking.

  But the ability to understand this highly visible implementation without the
  need for Nix expertise was determined to be important. Also, any
  implementation in which the output data structure is not a hard-coded literal
  would unfortunately mean that in order for some attributes to evaluate, some
  files that are in essence unnecessary for that evaluation would be nonetheless
  evaluated to some extent—a performance penalty that is deemed highly
  undesirable considering the pervasive use of this interface.
*/
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
