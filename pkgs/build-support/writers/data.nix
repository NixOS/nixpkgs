{ lib, pkgs, formats, runCommand }:
let
  inherit (lib)
    last
    optionalString
    types
    ;
in
{
  /**
    Creates a transformer function that writes input data to disk, transformed
    by both the `input` and `output` arguments.

    # Example

    ```nix
    writeJSON = makeDataWriter { input = builtins.toJSON; output = "cp $inputPath $out"; };
    myConfig = writeJSON "config.json" { hello = "world"; }
    ```

    # Type

    ```
    makeDataWriter :: input -> output -> nameOrPath -> data -> (any -> string) -> string -> string -> any -> derivation

    input :: T -> string: function that takes the nix data and returns a string
    output :: string: script that takes the $inputFile and write the result into $out
    nameOrPath :: string: if the name contains a / the files gets written to a sub-folder of $out. The derivation name is the basename of this argument.
    data :: T: the data that will be converted.
    ```
  */
  makeDataWriter = lib.warn "pkgs.writers.makeDataWriter is deprecated. Use pkgs.writeTextFile." ({ input ? lib.id, output ? "cp $inputPath $out" }: nameOrPath: data:
    assert (types.path.check nameOrPath) || (builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" nameOrPath != null);
    let
      name = last (builtins.split "/" nameOrPath);
    in
    runCommand name
      {
        input = input data;
        passAsFile = [ "input" ];
      } ''
      ${output}

      ${optionalString (types.path.check nameOrPath) ''
        mv $out tmp
        mkdir -p $out/$(dirname "${nameOrPath}")
        mv tmp $out/${nameOrPath}
      ''}
    '');

  inherit (pkgs) writeText;

  /**
    Writes the content to a JSON file.

    # Example

    ```nix
    writeJSON "data.json" { hello = "world"; }
    ```
  */
  writeJSON = (pkgs.formats.json {}).generate;

  /**
    Writes the content to a TOML file.

    # Example

    ```nix
    writeTOML "data.toml" { hello = "world"; }
    ```
  */
  writeTOML = (pkgs.formats.toml {}).generate;

  /**
    Writes the content to a YAML file.

    # Example

    ```nix
    writeYAML "data.yaml" { hello = "world"; }
    ```
  */
  writeYAML = (pkgs.formats.yaml {}).generate;
}
