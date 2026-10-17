{
  json-schema-catalog-rs,
  runCommand,
  writeText,
  formats,
}:
let

  sample = (formats.json { }).generate "example-schema.json" {
    "$schema" = "http://json-schema.org/draft-07/schema#";
    "$id" = "https://example.com/example-2.9.json";
    "title" = "Example Schema";
  };

  expectedOutput = writeText "expected-output" ''
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
in
runCommand "json-schema-catalog-rs-test-run"
  {
    nativeBuildInputs = [
      json-schema-catalog-rs
    ];
    inherit sample;
  }
  ''
    set -u

    # Test version
    json-schema-catalog --version | grep ${json-schema-catalog-rs.version}

    # Test a simple command
    json-schema-catalog new "$sample" > out.json
    diff -U3 "${expectedOutput}" out.json

    touch $out
  ''
