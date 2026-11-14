{
  callPackage,
  lib,
  kalamine,
}:
let
  filterOutNullValues = lib.filterAttrs (_: v: !isNull v);
in
# Creates a derivation from a directory containing TOML files. Can be used as a generic builder as well
src:
{
  # Let mkDerivation fail on its own if not enough attributes are set.
  name ? null,
  pname ? null,
  version ? null,
  homepage ? null,
  description ? null,
  args ? null, # kalamineBuildArgs
  extraDerivationArgs ? { },

  name8 ? null, # for fromLayout, the names of the files in the output.

  dontUnpack ? null,
}:
callPackage (
  { kalamine, stdenvNoCC }:
  stdenvNoCC.mkDerivation (
    finalAttrs:
    lib.mergeAttrsList [
      (filterOutNullValues {
        inherit
          pname
          version
          name
          dontUnpack
          ;
        kalamineBuildArgs = args;
        kalamineName8 = name8;
        passthru =
          if isNull name8 then
            null
          else
            {
              inherit name8;

              # easier access to resulting files
              getFile = sfx: "${finalAttrs.finalPackage}/${name8}.${sfx}";
            };
      })
      {
        strictDeps = true;
        __structuredArgs = true;
        inherit src;
        nativeBuildInputs = [ kalamine ];
        meta = filterOutNullValues { inherit description homepage; };
      }
      (
        if builtins.typeOf extraDerivationArgs == "lambda" then
          extraDerivationArgs finalAttrs
        else
          extraDerivationArgs
      )
    ]
  )
) { inherit kalamine; } # use finalPackage instead of package from pkgs.
