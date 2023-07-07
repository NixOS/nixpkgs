/*
  To run:

      nix-shell maintainers/scripts/update-dotnet-lockfiles.nix

  This script finds all the derivations in nixpkgs that have a 'fetch-deps'
  attribute, and runs all of them sequentially. This is useful to test changes
  to 'fetch-deps', 'nuget-to-nix', or other changes to the dotnet build
  infrastructure. Regular updates should be done through the individual packages
  update scripts.
 */
let
  pkgs = import ../.. {};

  inherit (pkgs) lib;

  packagesWith = cond: pkgs:
    let
      packagesWithInner = attrs:
        lib.unique (
          lib.concatLists (
            lib.mapAttrsToList (name: elem:
              let
                result = builtins.tryEval elem;
              in
                if result.success then
                  let
                    value = result.value;
                  in
                    if lib.isDerivation value then
                      lib.optional (cond value) value
                    else
                      if lib.isAttrs value && (value.recurseForDerivations or false || value.recurseForRelease or false) then
                        packagesWithInner value
                      else []
                else []) attrs));
    in
      packagesWithInner pkgs;

  packages =
    packagesWith (pkgs: pkgs ? fetch-deps) pkgs;

  helpText = ''
    Please run:

        % nix-shell maintainers/scripts/update-dotnet-lockfiles.nix
  '';

  fetchScripts = map (p: p.fetch-deps) packages;

in pkgs.stdenv.mkDerivation {
  name = "nixpkgs-update-dotnet-lockfiles";
  buildCommand = ''
    echo ""
    echo "----------------------------------------------------------------"
    echo ""
    echo "Not possible to update packages using \`nix-build\`"
    echo ""
    echo "${helpText}"
    echo "----------------------------------------------------------------"
    exit 1
  '';
  shellHook = ''
    unset shellHook # do not contaminate nested shells
    set -e
    for x in $fetchScripts; do
      $x
    done
    exit
  '';
  inherit fetchScripts;
}
