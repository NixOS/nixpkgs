{ lib, python313Packages, ... }@args:

let
  inherit (python313Packages.python-ironicclient) override;
in
python313Packages.toPythonApplication (
  override (
    removeAttrs args [
      "lib"
      "python313Packages"
    ]
    // lib.intersectAttrs (lib.functionArgs override) args
  )
)
