{ runCommand, nix, lib }:

# Replace a single dependency in the requisites tree of drv, propagating
# the change all the way up the tree, without a full rebuild. This can be
# useful, for example, to patch a security hole in libc and still use your
# system safely without rebuilding the world. This should be a short term
# solution, as soon as a rebuild can be done the properly rebuild derivation
# should be used. The old dependency and new dependency MUST have the same-length
# name, and ideally should have close-to-identical directory layout.
#
# Example: safeFirefox = replaceDependency {
#   drv = firefox;
#   oldDependency = glibc;
#   newDependency = overrideDerivation glibc (attrs: {
#     patches  = attrs.patches ++ [ ./fix-glibc-hole.patch ];
#   });
# };
# This will rebuild glibc with your security patch, then copy over firefox
# (and all of its dependencies) without rebuilding further.
{ drv, oldDependency, newDependency }:

with lib;

let
  references = import (runCommand "references.nix" { exportReferencesGraph = [ "graph" drv ]; } ''
    (echo {
    while read path
    do
        echo "  \"$path\" = ["
        read count
        read count
        while [ "0" != "$count" ]
        do
            read ref_path
            if [ "$ref_path" != "$path" ]
            then
                echo "    (builtins.storePath $ref_path)"
            fi
            count=$(($count - 1))
        done
        echo "  ];"
    done < graph
    echo }) > $out
  '').outPath;

  discard = builtins.unsafeDiscardStringContext;

  oldStorepath = builtins.storePath (discard (toString oldDependency));

  referencesOf = drv: getAttr (discard (toString drv)) references;

  dependsOnOld = drv: elem oldStorepath (referencesOf drv) ||
    any dependsOnOld (referencesOf drv);

  drvName = drv:
    discard (substring 33 (stringLength (builtins.baseNameOf drv)) (builtins.baseNameOf drv));

  rewriteHashes = drv: hashes: runCommand (drvName drv) { nixStore = "${nix}/bin/nix-store"; } ''
    $nixStore --dump ${drv} | sed 's|${baseNameOf drv}|'$(basename $out)'|g' | sed -e ${
      concatStringsSep " -e " (mapAttrsToList (name: value:
        "'s|${baseNameOf name}|${baseNameOf value}|g'"
      ) hashes)
    } | $nixStore --restore $out
  '';

  rewrittenDeps = listToAttrs [ {name = discard (toString oldDependency); value = newDependency;} ];

  rewrittenDerivations = drv:
    if dependsOnOld drv
      then listToAttrs [ {
        name = discard (toString drv);

        value = rewriteHashes drv (rewrittenDeps // (fold (drv: acc:
          (rewrittenDerivations drv) // acc
        ) {} (referencesOf drv)));
      } ]
      else {};
in assert (stringLength (drvName (toString oldDependency)) == stringLength (drvName (toString newDependency)));
getAttr (discard (toString drv)) (rewrittenDerivations drv)
