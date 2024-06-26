{
  cue,
  writeShellScript,
  lib,
}:
# `document` must be a fragment of definition or structure that the input data will be matched against.
# `document` must exist in the Cue schema file provided (`cueSchemaFile`).
# The result is a script that can be used to validate the input data (JSON/YAML and more can be supported depending on Cue)
# against the fragment described by `document` or the whole definition.
# The script will be strict and enforce concrete values, i.e. partial documents are not supported.
cueSchemaFile:
{
  document ? null,
}:
writeShellScript "validate-using-cue" ''
  ${cue}/bin/cue \
        --all-errors \
        --strict \
        vet \
        --concrete \
        "$1" \
        ${cueSchemaFile} \
        ${lib.optionalString (document != null) "-d \"${document}\""}
''
