# Utilities to extract and inject facts into docs.
#
# In this context, a documentation fact is a of documentation fragment that can be directly
# rendered by inspecting the attribute set returned by the nixpkgs repository root.
#
# From the point of view of the implementation, a fact generator is a function meant
# to be invoked with `pkgs.callPackage` and generates an attributeset with the fields:
#   - `id`: A unique id (string) to be used to find the injection/substitution marks inside the target file.
#   - `drv`: A derivation consisting of a file with the contents to be injected in the target file.
#   - `target`: The target file path (string) where the contents of `drv` are meant to be injected. The
#               injection/substitution is meant to happen in the `buildPhase` of the documentation
#               derivation.
#
# Each fact generator is expected to be inside a folder with name *FACT-ID*.

{ pkgs ? (import ./../../.. { }) }:
let
  inherit (pkgs) lib;
  inherit (lib.attrsets) foldlAttrs mapAttrsToList;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.lists) map;

  renderFact = { id }: (pkgs.callPackage (./generators + "/${id}") { inherit id; });

  facts = foldlAttrs
    # TODO: Typecheck that all attrset values are "directory".
    #       Alternatively, ignore anything but directories.
    (acc: id: _: acc ++ [ (renderFact { inherit id; }) ])
    [ ]
    (builtins.readDir ./generators);
in {
  # Convenience function to render an individual fact.
  # From this folder, call with:
  #   `nix-build --expr '(import ./. {}).renderFact' --argstr "id" "<FACT-ID>"`
  # Example:
  #   `nix-build --expr '(import ./. {}).renderFact' --argstr "id" "python-interpreter-table"`
  inherit renderFact;

  # Convenience derivation to check the rendering the collection of rendered facts.
  # From this folder, call with:
  #    `nix-build . --attr collected-facts`.
  collected-facts = let
    symlinkFn = fact: "ln -s ${fact.drv} $out/${fact.id}.md";
  in
    # The files are collected via `pkgs.runCommand` symlinking because
    # `pkgs.symlinkJoin` only works with folders.
    pkgs.runCommand "collected-facts" { }
      (concatStringsSep
        "\n"
        (["mkdir $out"] ++ (map symlinkFn facts)));

  # Attribute to be used during the build phase of documentation rendering.
  # alejandrosame: How to reuse substituteInPlace (stdenv shell functions and utilities)
  #                with writeShellApplication, writeScriptBin, etc?
  # From this folder, call with:
  #   `nix-instantiate --eval --expr '(import ./. {})' --attr substituteFactsInPlacePrefix`
  substituteFactsInPlacePrefix = let
    replacementString = fact: "<!-- FACT ${fact.id} -->";

    substituteInPlaceFactFn = fact: ''
      substituteInPlace \
        ${fact.target} \
        --replace-fail \
        "${replacementString fact}" \
        "$(cat ${fact.drv})"
    '';
  in
    concatStringsSep
      "\n"
      (map substituteInPlaceFactFn facts);
}