{ lib, python311Packages, ... }@args:

let
  inherit (python311Packages.j2cli) override;
in
python311Packages.toPythonApplication (
  override (
    removeAttrs args [
      "lib"
      "python311Packages"
    ]
    // lib.intersectAttrs (lib.functionArgs override) args
  )
)
