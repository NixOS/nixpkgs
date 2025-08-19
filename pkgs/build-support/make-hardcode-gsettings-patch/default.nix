{
  runCommand,
  gitMinimal,
  coccinelle,
  python3,
}:

/*
  Creates a patch that replaces every instantiation of GSettings in a C project
  with a code that loads a GSettings schema from a hardcoded path.

  This is useful so that libraries can find schemas even though Nix lacks
  a standard location like /usr/share, where GSettings system could look for schemas.
  The derivation is is somewhat dependency-heavy so it is best used as part of an update script.

  For each schema id referenced in the source code (e.g. org.gnome.evolution),
  a variable name such as `EVOLUTION` must be provided.
  It will end up in the generated patch as `@EVOLUTION@` placeholder, which should be replaced at build time
  with a path to the directory containing a `gschemas.compiled` file that includes the schema.

  Arguments:
  - `src`: source to generate the patch for.

  - `schemaIdToVariableMapping`: attrset assigning schema ids to variable names.
    All used schemas must be listed.

    For example, `{ "org.gnome.evolution" = "EVOLUTION_SCHEMA_PATH"; }`
    hardcodes looking for `org.gnome.evolution` into `@EVOLUTION_SCHEMA_PATH@`.

  - `schemaExistsFunction`: name of the function that is used for checking
    if optional schema exists. Its invocation will be replaced with TRUE
    for known schemas.

  - `patches`: A list of patches to apply before generating the patch.

  Example:
    passthru = {
      hardcodeGsettingsPatch = makeHardcodeGsettingsPatch {
        inherit (finalAttrs) src;
        schemaIdToVariableMapping = {
           ...
        };
      };

      updateScript =
        let
          updateSource = ...;
          updatePatch = _experimental-update-script-combinators.copyAttrOutputToFile "evolution-ews.hardcodeGsettingsPatch" ./hardcode-gsettings.patch;
        in
        _experimental-update-script-combinators.sequence [
          updateSource
          updatePatch
        ];
      };
    }
*/
{
  src,
  patches ? [ ],
  schemaIdToVariableMapping,
  schemaExistsFunction ? null,
}:

runCommand "hardcode-gsettings.patch"
  {
    inherit src patches;
    nativeBuildInputs = [
      gitMinimal
      coccinelle
      python3 # For patch script
    ];
  }
  ''
    unpackPhase
    cd "''${sourceRoot:-.}"
    patchPhase
    set -x
    cp ${builtins.toFile "glib-schema-to-var.json" (builtins.toJSON schemaIdToVariableMapping)} ./glib-schema-to-var.json
    cp ${builtins.toFile "glib-schema-exists-function.json" (builtins.toJSON schemaExistsFunction)} ./glib-schema-exists-function.json
    git init
    git add -A
    spatch --sp-file "${./hardcode-gsettings.cocci}" --dir . --in-place
    git diff > "$out"
  ''
