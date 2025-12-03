{ lib, python3Packages, ... }@args:

let
  inherit (python3Packages.git-filter-repo) override;
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
