{ lib, runCommand, nixpkgs-fmt, nix }:
# Merge a list of self contained NixOS modules together in to a single file.
# Note: since these modules will be aggregated in to a new, single file, they
# should not refer to other files using relative paths.
{
  # The name of the resulting file. Note the result of this builder is
  # a single-file output, ie: /nix/store/<hash>-${name}
  name ? "configuration.nix"

  # A list of files containing NixOS modules to merge together.
, moduleFiles
}:
let
  validateOneScript = file:
    ''
      printf "Validating file %s...\n" ${lib.escapeShellArg file};
      if ! nix-instantiate --parse ${lib.escapeShellArg file} > /dev/null; then
        cat -n ${lib.escapeShellArg file}
        invalid=1
      else
        echo "....Ok."
      fi
    '';

  validateListScript = files: lib.concatMapStringsSep "\n" validateOneScript files;

  produceOneScript = file:
    let
      template = ''
        {
          _file = "${name}:merged-from:%s";
          imports = [ (%s) ];
        }
      '';
    in
    ''
      printf ${lib.escapeShellArg template} ${lib.escapeShellArg file} "$(cat ${lib.escapeShellArg file})"
    '';

  importListScript = files: lib.concatMapStringsSep "\n" produceOneScript files;

in
runCommand name
{
  buildInputs = [ nixpkgs-fmt nix ];
} ''
  export NIX_STATE_DIR=$TMPDIR

  (
    invalid=0
    echo "Validating the input configuration files before merging..."
    ${validateListScript moduleFiles}

    if [ $invalid -ne 0 ]; then
      echo "Input modules failed validation, cannot merge."
      exit 1
    fi
  )

  (
    echo '{ imports = [';
    ${importListScript moduleFiles}
    echo ']; }'
  ) > $out

  echo "Formatting the merged configuration file..."
  nixpkgs-fmt "$out"

  (
    invalid=0
    ${validateOneScript (builtins.placeholder "out")}
    exit $invalid
  )
''


