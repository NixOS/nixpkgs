# Fetches a directory recursively
# IMPORTANT: The hash will change when upstream touches a file
# in the folder. So make sure that doesn’t happen or older
# nixpkgs version will have broken derivations!

# Note that this is a last solution when all other fetchers
# are not up to the job. In particular, if there’s only a small
# number of files use fetchurl and enter their hashes manually.
# Even if it’s a lot of files, it might be better to create a mirror
# repository and make a release.

{ stdenv, wget }:
{ url, sha256 ? ""
# the number of directory components that should be ignored
# see wget(1) option --cut-dirs
, cut-dirs ? 0 }:

assert builtins.isInt cut-dirs;

stdenv.mkDerivation {
  name = "${baseNameOf (toString url)}-srcdir";

  buildInputs = [ wget ];
  builder = ./builder.sh;
  cut_dirs = cut-dirs;
  inherit url;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
}
