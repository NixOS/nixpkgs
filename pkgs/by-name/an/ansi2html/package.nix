{ lib, python3Packages, ... }@args:

let
  inherit (python3Packages.ansi2html) override;
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
