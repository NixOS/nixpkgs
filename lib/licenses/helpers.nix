{ lib }:
let
  recCheck =
    check: attrs:
    if attrs.type == "simple" then
      check attrs
    else if attrs.type == "compound" then
      if attrs.operator == "OR" then
        recCheck check attrs.base || recCheck check attrs.mod
      else if attrs.operator == "AND" then
        recCheck check attrs.base && recCheck check attrs.mod
      else if attrs.operator == "WITH" then
        recCheck check attrs.base && recCheck check attrs.mod
      else
        throw "Unknown license operator"
    else
      throw "Unknown license type or legacy license";
  recCheck' =
    check: attrs:
    if attrs.type == "simple" then
      check attrs
    else if attrs.type == "compound" then
      if attrs.operator == "OR" then
        recCheck check attrs.base && recCheck check attrs.mod
      else if attrs.operator == "AND" then
        recCheck check attrs.base || recCheck check attrs.mod
      else if attrs.operator == "WITH" then
        recCheck check attrs.base || recCheck check attrs.mod
      else
        throw "Unknown license operator"
    else
      throw "Unknown license type or legacy license";
in
rec {
  /**
    Check wether a license is unfree.

    # Example

    ```nix
    isUnfree lib.licenses.mit
    => true
    ```

    # Type

    ```
    isUnfree :: AttrSet -> Bool
    ```

    # Arguments

    - [license] License to check if unfree
  */
  isUnfree = recCheck' (x: !x.free);

  /**
    Check wether a license is redistributable.

    # Example

    ```nix
    isRedistributable lib.licenses.mit
    => true
    ```

    # Type

    ```
    isRedistributable :: AttrSet -> Bool
    ```

    # Arguments

    - [license] License to check if redistributable
  */
  isRedistributable = recCheck (x: x.redistributable);

  /**
    Check wether a licenses are conatined with in a license.

    # Example

    ```nix
    containsLicenses [ lib.licenses.asl20 ] lib.licenses.mit
    => false
    ```

    # Type

    ```
    containsLicenses :: List -> AttrSet -> Bool
    ```

    # Arguments

    - [licenses] Licenses which should be checked if they are included
    - [license] License to check if it included one of the other licenses
  */
  containsLicenses = licenses: recCheck' (x: lib.lists.elem x licenses);

  /**
    Convert a licenses to an SPDX license expression string

    # Example

    ```nix
    toSpdxExpression lib.licenses.mit
    => "MIT"
    ```

    # Type

    ```
    toSpdxExpression :: AttrSet -> String
    ```

    # Arguments

    - [license] Licenses which to convert to spdx expression
  */
  toSpdxExpression =
    license:
    let
      mkBracket = x: if x.type == "compound" then "(${toSpdxExpression x})" else toSpdxExpression x;
    in
    if license.type == "simple" then
      license.spdxId or "LicenseRef-nixos-${license.shortName}"
    else if license.type == "compound" then
      "${mkBracket license.base} ${license.operator} ${mkBracket license.mod}"
    else
      throw "Unknown license type";
}
