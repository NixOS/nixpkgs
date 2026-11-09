{
  lib,
  pkgs,
  formats,
  runCommand,
}:
let
  inherit (lib)
    last
    optionalString
    types
    ;
in
{
  makeDataWriter = throw "pkgs.writers.makeDataWriter has been removed. Use pkgs.writeTextFile instead.";

  inherit (pkgs) writeText;

  /**
    Writes the content to a JSON file.

    # Example

    ```nix
    writeJSON "data.json" { hello = "world"; }
    ```
  */
  writeJSON = (pkgs.formats.json { }).generate;

  /**
    Writes the content to a TOML file.

    # Example

    ```nix
    writeTOML "data.toml" { hello = "world"; }
    ```
  */
  writeTOML = (pkgs.formats.toml { }).generate;

  /**
    Writes the content to a YAML file.

    # Example

    ```nix
    writeYAML "data.yaml" { hello = "world"; }
    ```
  */
  writeYAML = (pkgs.formats.yaml { }).generate;
}
