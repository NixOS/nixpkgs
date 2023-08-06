{ lib, stdenv, buildPackages }:

# This function is for creating a flat-file binary cache, i.e. the kind created by
# nix copy --to file:///some/path and usable as a substituter (with the file:// prefix).

# For example, in the Nixpkgs repo:
# nix-build -E 'with import ./. {}; mkBinaryCache { rootPaths = [hello]; }'

{ name ? "binary-cache"
, rootPaths
}:

stdenv.mkDerivation {
  inherit name;

  __structuredAttrs = true;

  exportReferencesGraph.closure = rootPaths;

  preferLocalBuild = true;

  PATH = lib.makeBinPath (with buildPackages; [ coreutils jq python3 nix xz ]);

  builder = builtins.toFile "builder" ''
    . .attrs.sh

    export out=''${outputs[out]}

    mkdir $out
    mkdir $out/nar

    python ${./make-binary-cache.py}

    # These directories must exist, or Nix might try to create them in LocalBinaryCacheStore::init(),
    # which fails if mounted read-only
    mkdir $out/realisations
    mkdir $out/debuginfo
    mkdir $out/log
  '';
}
