/*
  To run:

      nix-shell maintainers/scripts/update-dotnet-lockfiles.nix

  This script finds all the derivations in nixpkgs that have a 'fetch-deps'
  attribute, and runs all of them sequentially. This is useful to test changes
  to 'fetch-deps', 'nuget-to-json', or other changes to the
  dotnet build infrastructure. Regular updates should be done through the
  individual packages update scripts.
*/
{ ... }@args:
import ./update.nix (
  {
    predicate = _: _: true;
    get-script = pkg: pkg.fetch-deps or null;
  }
  // args
)
