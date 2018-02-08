{ system }:
# fetchSources is useful when multiple sources are available for a package,
# usually for binary releases.
#
# Since all the sources are being exposed back in the "sources" attribute,
# it allows for hash-updating scripts to update all of them.
#
# This effectively reserves the "sources" attribute on all the fetchers.
#
# Example usage:
#
#    stdenv.mkDerivation {
#      name = "foo";
#      version = "1.0.0";
#
#      src = fetchSources {
#        x86_64-linux = fetchurl {
#          url = "https://foo.com/foo-amd64-${version}.tar.gz";
#          sha256 = "...";
#        };
#
#        x86_64-darwin = fetchurl {
#          url = "https://foo.com/foo-darwin-${version}.tar.gz";
#          sha256 = "...";
#        };
#      } pkgs.system;
#    };
#
sources: key:
  let
    fetcher = sources."${key}" or (throw "fetcher for key '${key}' not supported");
  in
    fetcher // { inherit sources; }
