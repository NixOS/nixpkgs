{
  runCommand,
  git,
  coccinelle,
  python3,
}:

/*
  Can be used as part of an update script to automatically create a patch
  hardcoding the path of all GSettings schemas in C code.
  For example:
  passthru = {
    hardcodeGsettingsPatch = makeHardcodeGsettingsPatch {
      inherit src;
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
  takes as input a mapping from schema path to variable name.
  For example `{ "org.gnome.evolution" = "EVOLUTION_SCHEMA_PATH"; }`
  hardcodes looking for `org.gnome.evolution` into `@EVOLUTION_SCHEMA_PATH@`.
  All schemas must be listed.
*/
{
  src,
  schemaIdToVariableMapping,
}:

runCommand
  "hardcode-gsettings.patch"
  {
    inherit src;
    nativeBuildInputs = [
      git
      coccinelle
      python3 # For patch script
    ];
  }
  ''
    unpackPhase
    cd "''${sourceRoot:-.}"
    set -x
    cp ${builtins.toFile "glib-schema-to-var.json" (builtins.toJSON schemaIdToVariableMapping)} ./glib-schema-to-var.json
    git init
    git add -A
    spatch --sp-file "${./hardcode-gsettings.cocci}" --dir . --in-place
    git diff > "$out"
  ''
