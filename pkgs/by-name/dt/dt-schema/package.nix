{
  lib,
  python3,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      # see https://github.com/devicetree-org/dt-schema/issues/108
      jsonschema = super.jsonschema.overridePythonAttrs (old: rec {
        version = "4.17.3";
        disabled = self.pythonOlder "3.7";

        src = old.src.override {
          inherit version;
          hash = "sha256-D4ZEN6uLYHa6ZwdFPvj5imoNUSqA6T+KvbZ29zfstg0=";
        };

        propagatedBuildInputs =
          with self;
          (
            [
              attrs
              pyrsistent
            ]
            ++ lib.optionals (pythonOlder "3.8") [
              importlib-metadata
              typing-extensions
            ]
            ++ lib.optionals (pythonOlder "3.9") [
              importlib-resources
              pkgutil-resolve-name
            ]
          );
      });
    };
  };
in
python.pkgs.toPythonApplication python.pkgs.dtschema
