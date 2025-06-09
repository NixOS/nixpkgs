{
  json-schema-catalog-rs,
  runCommand,
}:
let

  sample = builtins.toFile "example-schema.json" (
    builtins.toJSON {
      "$schema" = "http://json-schema.org/draft-07/schema#";
      "$id" = "https://example.com/example-2.9.json";
      "title" = "Example Schema";
    }
  );

in
runCommand "json-schema-catalog-rs-test-run"
  {
    nativeBuildInputs = [
      json-schema-catalog-rs
    ];
    inherit sample;
    expectedOutput = ''
      {
        "groups": [
          {
            "baseLocation": "/nix/store",
            "name": "Example Schema",
            "schemas": [
              {
                "id": "https://example.com/example-2.9.json",
                "location": "${baseNameOf sample}"
              }
            ]
          }
        ],
        "name": "Catalog"
      }
    '';
    passAsFile = [
      "expectedOutput"
    ];
  }
  ''
    set -u

    # Test version
    json-schema-catalog --version | grep ${json-schema-catalog-rs.version}

    # Test a simple command
    json-schema-catalog new "$sample" > out.json
    diff -U3 "$expectedOutputPath" out.json

    touch $out
  ''
