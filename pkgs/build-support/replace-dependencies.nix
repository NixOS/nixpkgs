{
  lib,
  runCommandLocal,
  replaceDirectDependencies,
}:

# Replace some dependencies in the requisites tree of drv, propagating the change all the way up the tree, even within other replacements, without a full rebuild.
# This can be useful, for example, to patch a security hole in libc and still use your system safely without rebuilding the world.
# This should be a short term solution, as soon as a rebuild can be done the properly rebuilt derivation should be used.
# Each old dependency and the corresponding new dependency MUST have the same-length name, and ideally should have close-to-identical directory layout.
#
# Example: safeFirefox = replaceDependencies {
#   drv = firefox;
#   replacements = [
#     {
#       oldDependency = glibc;
#       newDependency = glibc.overrideAttrs (oldAttrs: {
#         patches = oldAttrs.patches ++ [ ./fix-glibc-hole.patch ];
#       });
#     }
#     {
#       oldDependency = libwebp;
#       newDependency = libwebp.overrideAttrs (oldAttrs: {
#         patches = oldAttrs.patches ++ [ ./fix-libwebp-hole.patch ];
#       });
#     }
#   ];
# };
# This will first rebuild glibc and libwebp with your security patches.
# Then it copies over firefox (and all of its dependencies) without rebuilding further.
# In particular, the glibc dependency of libwebp will be replaced by the patched version as well.
#
# In rare cases, it is possible for the replacement process to cause breakage (for example due to checksum mismatch).
# The cutoffPackages argument can be used to exempt the problematic packages from the replacement process.
{
  drv,
  replacements,
  cutoffPackages ? [ ],
  verbose ? true,
}:

let
  inherit (builtins) unsafeDiscardStringContext appendContext;
  inherit (lib)
    listToAttrs
    isStorePath
    readFile
    attrValues
    mapAttrs
    filter
    hasAttr
    mapAttrsToList
    ;
  inherit (lib.attrsets) mergeAttrsList;

  toContextlessString = x: unsafeDiscardStringContext (toString x);
  warn = if verbose then lib.warn else (x: y: y);

  referencesOf =
    drv:
    import
      (runCommandLocal "references.nix"
        {
          exportReferencesGraph = [
            "graph"
            drv
          ];
        }
        ''
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
                      echo "    \"$ref_path\""
                  fi
                  count=$(($count - 1))
              done
              echo "  ];"
          done < graph
          echo }) > $out
        ''
      ).outPath;

  realisation =
    drv:
    if isStorePath drv then
      # Input-addressed and fixed-output derivations have their realisation as outPath.
      toContextlessString drv
    else
      # Floating and deferred derivations have a placeholder outPath.
      # The realisation can only be obtained by performing an actual build.
      unsafeDiscardStringContext (
        readFile (
          runCommandLocal "realisation"
            {
              env = {
                inherit drv;
              };
            }
            ''
              echo -n "$drv" > $out
            ''
        )
      );
  rootReferences = referencesOf drv;
  relevantReplacements = filter (
    { oldDependency, newDependency }:
    if toString oldDependency == toString newDependency then
      warn "replaceDependencies: attempting to replace dependency ${oldDependency} of ${drv} with itself"
        # Attempting to replace a dependency by itself is completely useless, and would only lead to infinite recursion.
        # Hence it must not be attempted to apply this replacement in any case.
        false
    else if !hasAttr (realisation oldDependency) rootReferences then
      warn "replaceDependencies: ${drv} does not depend on ${oldDependency}, so it will not be replaced"
        # Strictly speaking, another replacement could introduce the dependency.
        # However, handling this corner case would add significant complexity.
        # So we just leave it to the user to apply the replacement at the correct place, but show a warning to let them know.
        false
    else
      true
  ) replacements;
  targetDerivations = [ drv ] ++ map ({ newDependency, ... }: newDependency) relevantReplacements;
  referencesMemo = listToAttrs (
    map (drv: {
      name = realisation drv;
      value = referencesOf drv;
    }) targetDerivations
  );
  relevantReferences = mergeAttrsList (attrValues referencesMemo);
  # Make sure a derivation is returned even when no replacements are actually applied.
  # Yes, even in the stupid edge case where the root derivation itself is replaced.
  storePathOrKnownTargetDerivationMemo =
    mapAttrs (
      drv: _references:
      # builtins.storePath does not work in pure evaluation mode, even though it is not impure.
      # This reimplementation in Nix works as long as the path is already allowed in the evaluation state.
      # This is always the case here, because all paths come from the closure of the original derivation.
      appendContext drv { ${drv}.path = true; }
    ) relevantReferences
    // listToAttrs (
      map (drv: {
        name = realisation drv;
        value = drv;
      }) targetDerivations
    );

  rewriteMemo =
    # Mind the order of how the three attrsets are merged here.
    # The order of precedence needs to be "explicitly specified replacements" > "rewrite exclusion (cutoffPackages)" > "rewrite".
    # So the attrset merge order is the opposite.
    mapAttrs (
      drv: references:
      let
        rewrittenReferences = filter (dep: dep != drv && toString rewriteMemo.${dep} != dep) references;
        rewrites = listToAttrs (
          map (reference: {
            name = reference;
            value = rewriteMemo.${reference};
          }) rewrittenReferences
        );
      in
      replaceDirectDependencies {
        drv = storePathOrKnownTargetDerivationMemo.${drv};
        replacements = mapAttrsToList (name: value: {
          oldDependency = name;
          newDependency = value;
        }) rewrites;
      }
    ) relevantReferences
    // listToAttrs (
      map (drv: {
        name = realisation drv;
        value = storePathOrKnownTargetDerivationMemo.${realisation drv};
      }) cutoffPackages
    )
    // listToAttrs (
      map (
        { oldDependency, newDependency }:
        {
          name = realisation oldDependency;
          value = rewriteMemo.${realisation newDependency};
        }
      ) relevantReplacements
    );
in
rewriteMemo.${realisation drv}
