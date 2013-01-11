{ runCommand, nix, lib }:

# Replace a single dependency in the requisites tree of drv, propagating
# the change all the way up the tree, without a full rebuild. This can be
# useful, for example, to patch a security hole in libc and still use your
# system safely without rebuilding the world. This should be a short term
# solution, as soon as a rebuild can be done the properly rebuild derivation
# should be used. The old dependency and new dependency MUST have the same-length
# name, and ideally should have close-to-identical directory layout.
#
# Example: safe-firefox = replace-dependency {
#   drv = firefox;
#   old-dependency = glibc;
#   new-dependency = overrideDerivation glibc (attrs: {
#     patches  = attrs.patches ++ [ ./fix-glibc-hole.patch ];
#   });
# };
# This will rebuild glibc with your security patch, then copy over firefox
# (and all of its dependencies) without rebuilding further.
{ drv, old-dependency, new-dependency }:

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

  old-storepath = builtins.storePath (discard old-dependency.outPath);

  references-of = drv: getAttr (discard (toString drv)) references;

  depends-on-old = drv: elem old-storepath (references-of drv) ||
    any depends-on-old (references-of drv);

  drv-name = drv:
    discard (substring 33 (stringLength (builtins.baseNameOf drv)) (builtins.baseNameOf drv));

  replace-strings = drv: rewritten-drvs: runCommand (drv-name drv) { nixStore = "${nix}/bin/nix-store"; } ''
    $nixStore --dump ${drv} | sed 's|${baseNameOf drv}|'$(basename $out)'|g' | sed -e ${
      concatStringsSep " -e " (mapAttrsToList (name: value:
        "'s|${baseNameOf name}|${baseNameOf value}|g'"
      ) rewritten-drvs)
    } | $nixStore --restore $out
  '';

  rewritten-deps = listToAttrs [ {name = discard old-dependency.outPath; value = new-dependency;} ];

  fn = drv:
    if depends-on-old drv
      then listToAttrs [ {
        name = discard (toString drv);

        value = replace-strings drv (rewritten-deps // (fold (drv: acc:
          (fn drv) // acc
        ) {} (references-of drv)));
      } ]
      else {};
in assert (stringLength old-dependency.name == stringLength new-dependency.name);
getAttr (discard drv.outPath) (fn drv)
