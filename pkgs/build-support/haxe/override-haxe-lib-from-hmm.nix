{
  lib,
  haxePackages,
  fetchgit,
  fetchzip,
}:

/**
  This tool can be used to convert as set of derivation containing haxe dependencies (as from haxe-packages.nix) to use version specified in an hmm.json file, used by certain project as a lock file.
  To update (or initiate it) for a package:
    1. copy the hmm.json file in the package folder
    2. run update-hmm-hashes.py (you will to have nix-prefetch-git in the PATH, which is packaged in nixpkgs under the same name).
      It take as argument a path to the hmm.json file, and a path to an output json file that contains the hashes for the dependancies (usually named hashes.json)
    3. In the Nix package file, call this function with at least an hmm file, an hashes file, and a list of haxe packages that are to be overwritten.

  # Inputs

  `hmm` (AttrSet)

  : The content of JSON hmm.json file, already loaded (like with lib.importJSON)

  `hashes` (AttrSet)

  : The content of the hashes.json file, already loaded (like with lib.importJSON)

  `packages` ([Derivation])

  : List of haxe packages as built by `buildHaxeLib`
*/
{
  hmm,
  hashes,
  packages,
}:

let
  index_override = lib.listToAttrs (
    map (override: {
      name = override.name;
      value = override;
    }) hmm.dependencies
  );

  fetch_overriden_source =
    override:
    if override.type == "git" then
      fetchgit {
        url = override.url;
        rev = override.ref;
        hash = hashes."git-${override.ref}";
      }
    else if override.type == "haxelib" then
      fetchzip {
        url = "http://lib.haxe.org/files/3.0/${
          lib.replaceStrings [ "." ] [ "," ] "${override.name}-${override.version}"
        }.zip";
        hash = hashes."haxelib-${override.name}-${override.version}";
      }
    else
      throw "Unsupported hmm dependency type \"${override.type}\"";

  override_haxe_dependencies =
    derivations:
    map (
      d:
      let
        libname = ((d.passthru or { }).haxe_libname or null);
      in
      if libname != null then
        if libname ? overriden_packages then overriden_packages."${libname}" else d
      else
        d
    ) derivations;

  override_package =
    package:
    let
      libname = package.passthru.haxe_libname;

      overrided_src_but_no_build_override =
        if lib.hasAttr libname index_override then
          let
            new_source = fetch_overriden_source index_override."${libname}";
          in
          if new_source != null then
            package.overrideAttrs (old: {
              src = new_source;
            })
          else
            package
        else
          package;

      overrided_src_and_input = overrided_src_but_no_build_override.overrideAttrs (old: {
        buildInputs = override_haxe_dependencies (old.buildInputs or [ ]);
        propagatedBuildInputs = override_haxe_dependencies (old.propagatedBuildInputs or [ ]);
      });
    in
    overrided_src_and_input;

  overriden_packages = lib.listToAttrs (
    map (package: {
      name = package.passthru.haxe_libname;
      value = override_package package;
    }) packages
  );
in
lib.mapAttrsToList (name: value: value) overriden_packages
