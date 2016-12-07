{ lib, fetchdata }:

# Similar to fetchdata but allows to switch on an attribute
#
# Example usage:
#
#     fetchmulti stdenv.system {
#        "x86_64-linux" = {
#          url = "http://example.com/x86-linux.tar.gz";
#          sha256 = "...";
#        };
#        "i686-linux" = {
#          url = "http://example.com/i686-linux.tar.gz";
#          sha256 = "...";
#        };
#     }
#
# All the urls are exposed on the `all' attribute which allows to run
# `nix-fetchetch-url -A mypackage.src.all` to calculate the checksums of the:q
#
# FIXME: right now nix-prefetch-url only work if one of the keys match the
#        current plaform
#
key: data:
let
  attrs = data."${key}" or (throw "`${key}' is not available as a source");

  # A list of all the fetcher urls
  urls = lib.foldl
    (sum: v: ((fetchdata v).urls or []) ++ sum)
    []
    (builtins.attrValues data);
in
  (fetchdata attrs) // { all = { inherit urls; }; }


