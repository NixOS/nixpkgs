{ lib, python312Packages, ... }@args:

let
  inherit (python312Packages.reno) override;
in
python312Packages.toPythonApplication (
  override (
    removeAttrs args [
      "lib"
      "python312Packages"
    ]
    // lib.intersectAttrs (lib.functionArgs override) args
  )
)
