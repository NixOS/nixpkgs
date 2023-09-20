{ lib, runCommand, dasel }:
let
  daselBin = lib.getExe dasel;

  inherit (lib)
    last
    optionalString
    types
    ;
in
rec {
  # Creates a transformer function that writes input data to disk, transformed
  # by both the `input` and `output` arguments.
  #
  # Type: makeDataWriter :: input -> output -> nameOrPath -> data -> (any -> string) -> string -> string -> any -> derivation
  #
  #   input :: T -> string: function that takes the nix data and returns a string
  #   output :: string: script that takes the $inputFile and write the result into $out
  #   nameOrPath :: string: if the name contains a / the files gets written to a sub-folder of $out. The derivation name is the basename of this argument.
  #   data :: T: the data that will be converted.
  #
  # Example:
  #   writeJSON = makeDataWriter { input = builtins.toJSON; output = "cp $inputPath $out"; };
  #   myConfig = writeJSON "config.json" { hello = "world"; }
  #
  makeDataWriter = { input ? lib.id, output ? "cp $inputPath $out" }: nameOrPath: data:
    assert lib.or (types.path.check nameOrPath) (builtins.match "([0-9A-Za-z._])[0-9A-Za-z._-]*" nameOrPath != null);
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
    '';

  # Writes the content to text.
  #
  # Example:
  #   writeText "filename.txt" "file content"
  writeText = makeDataWriter {
    input = toString;
    output = "cp $inputPath $out";
  };

  # Writes the content to a JSON file.
  #
  # Example:
  #   writeJSON "data.json" { hello = "world"; }
  writeJSON = makeDataWriter {
    input = builtins.toJSON;
    output = "${daselBin} -f $inputPath -r json -w json > $out";
  };

  # Writes the content to a TOML file.
  #
  # Example:
  #   writeTOML "data.toml" { hello = "world"; }
  writeTOML = makeDataWriter {
    input = builtins.toJSON;
    output = "${daselBin} -f $inputPath -r json -w toml > $out";
  };

  # Writes the content to a YAML file.
  #
  # Example:
  #   writeYAML "data.yaml" { hello = "world"; }
  writeYAML = makeDataWriter {
    input = builtins.toJSON;
    output = "${daselBin} -f $inputPath -r json -w yaml > $out";
  };
}
