{ lib, python310Packages, ... }@args:

let
  inherit (python310Packages.circus) override;
in
python310Packages.toPythonApplication (
  override (
    removeAttrs args [
      "lib"
      "python310Packages"
    ]
    // lib.intersectAttrs (lib.functionArgs override) args
  )
)
