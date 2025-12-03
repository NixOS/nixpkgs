{ lib, python3Packages, ... }@args:

let
  inherit (python3Packages.json-schema-for-humans) override;
in
python3Packages.toPythonApplication (
  override (
    removeAttrs args [
      "lib"
      "python3Packages"
    ]
    // lib.intersectAttrs (lib.functionArgs override) args
  )
)
