{ lib, python313Packages, ... }@args:

let
  inherit (python313Packages.python-openstackclient) override;
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
