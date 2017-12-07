# This derivation builds two files containing information about the
# closure of 'rootPaths': $out/store-paths contains the paths in the
# closure, and $out/registration contains a file suitable for use with
# "nix-store --load-db" and "nix-store --register-validity
# --hash-given".

{ stdenv, coreutils, jq, perl, pathsFromGraph }:

{ rootPaths }:

#if builtins.langVersion >= 5 then
# FIXME: it doesn't work on Hydra, failing to find mkdir;
#   perhaps .attrs.sh clobbers PATH with new nix?
if false then

  # Nix >= 1.12: Include NAR hash / size info.

  stdenv.mkDerivation {
    name = "closure-info";

    __structuredAttrs = true;

    exportReferencesGraph.closure = rootPaths;

    PATH = "${coreutils}/bin:${jq}/bin";

    builder = builtins.toFile "builder"
      ''
        if [ -e .attrs.sh ]; then . .attrs.sh; fi

        out=''${outputs[out]}

        mkdir $out

        jq -r '.closure | map([.path, .narHash, .narSize, "", (.references | length)] + .references) | add | map("\(.)\n") | add' < .attrs.json | head -n -1 > $out/registration
        jq -r .closure[].path < .attrs.json > $out/store-paths
      '';
  }

else

  # Nix < 1.12

  stdenv.mkDerivation {
    name = "closure-info";

    exportReferencesGraph =
      map (x: [("closure-" + baseNameOf x) x]) rootPaths;

    buildInputs = [ perl ];

    buildCommand =
      ''
        mkdir $out
        printRegistration=1 perl ${pathsFromGraph} closure-* > $out/registration
        perl ${pathsFromGraph} closure-* > $out/store-paths
      '';
  }
