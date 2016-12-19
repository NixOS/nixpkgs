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
{ drv, oldDependency, newDependency, verbose ? true }:

with lib;

let
  warn = if verbose then builtins.trace else (x:y:y);
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

  referencesOf = drv: references.${discard (toString drv)};

  dependsOnOldMemo = listToAttrs (map
    (drv: { name = discard (toString drv);
            value = elem oldStorepath (referencesOf drv) ||
                    any dependsOnOld (referencesOf drv);
          }) (builtins.attrNames references));

  dependsOnOld = drv: dependsOnOldMemo.${discard (toString drv)};

  drvName = drv:
    discard (substring 33 (stringLength (builtins.baseNameOf drv)) (builtins.baseNameOf drv));

  rewriteHashes = drv: hashes: runCommand (drvName drv) { nixStore = "${nix.out}/bin/nix-store"; } ''
    $nixStore --dump ${drv} | sed 's|${baseNameOf drv}|'$(basename $out)'|g' | sed -e ${
      concatStringsSep " -e " (mapAttrsToList (name: value:
        "'s|${baseNameOf name}|${baseNameOf value}|g'"
      ) hashes)
    } | $nixStore --restore $out
  '';

  rewrittenDeps = listToAttrs [ {name = discard (toString oldDependency); value = newDependency;} ];

  rewriteMemo = listToAttrs (map
    (drv: { name = discard (toString drv);
            value = rewriteHashes (builtins.storePath drv)
              (filterAttrs (n: v: builtins.elem (builtins.storePath (discard (toString n))) (referencesOf drv)) rewriteMemo);
          })
    (filter dependsOnOld (builtins.attrNames references))) // rewrittenDeps;

  drvHash = discard (toString drv);
in assert (stringLength (drvName (toString oldDependency)) == stringLength (drvName (toString newDependency)));
rewriteMemo.${drvHash} or (warn "replace-dependency.nix: Derivation ${drvHash} does not depend on ${discard (toString oldDependency)}" drv)
