{ fetchers }:

# One fetcher to rule them all.
#
# The input should only be pure nix data, no function calls.
#
# Example usage:
#
#    fetchurl {
#      url = "http://example.com/archive.tar.gz";
#      sha256 = "...";
#    };
#
# Becomes:
#
#    fetchdata {
#      url = "http://example.com/archive.tar.gz";
#      sha256 = "...";
#    }
#
# If the data is not for fetchurl, it's possible to pass a "fetcher"
# attribute:
#
#    fetchdata {
#      fetcher = "fetchFromGitHub";
#      repo    = "someone";
#      repo    = "something";
#      rev     = "v1.0";
#      sha256  = "...";
#    }
#
# Which means that the attributes can now be imported
#
#    fetchdata (import ./source.nix);
#
# That's the whole point of this function.
#
{ fetcher ? "fetchurl", ... }@attrs:
  let
    # TODO: add heuristic based on the input data instead
    fetcher' =
      fetchers."${fetcher}" or
        (throw "fetcher of type `${fetcher}' not supported");
    attrs' = builtins.removeAttrs attrs ["fetcher"];
  in
    fetcher' attrs'
