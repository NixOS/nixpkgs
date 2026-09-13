{ lib }:

let
  inherit (lib) all any elem;
  handleComplexProperty =
    evaluateSubProperty: AND: OR: license:
    if license.licenseType == "compound" then
      if license.operator == "OR" then
        OR evaluateSubProperty license.licenses
      else if license.operator == "AND" then
        AND evaluateSubProperty license.licenses
      else
        throw "Unknown license operator"
    else if license.licenseType == "exception" then
      evaluateSubProperty license.license && evaluateSubProperty license.exception
    else if license.licenseType == "plus" then
      evaluateSubProperty license.license
    else
      throw "Unknown license type or legacy license";
in
rec {
  /**
    Evaluate a license expression for a given predicate.

    # Inputs

    `predicate`
    : Predicate which should get used for checking licenses

    `permissive`
    : Whether to apply checks permissive or reciprocal

    `license`
    : License expression which should be evaluated

    # Type

    ```
    evaluateProperty :: (a -> Bool) -> Bool -> { [String] :: a } -> Bool
    ```

    # Example
    :::{.example}
    ## `lib.licenses.evaluateProperty usage example`

    ```nix
    evaluateProperty (x: x.free) true (with lib.licenses; AND [ ncsa (WITH asl20 llvm-exception) ])
    => true
    ```
  */
  evaluateProperty =
    predicate: permissive:
    let
      OR = if permissive then any else all;
      AND = if permissive then all else any;
      evaluateComplexProperty = handleComplexProperty (evaluateProperty predicate permissive) AND OR;
    in
    license:
    if license.licenseType == "simple" then predicate license else evaluateComplexProperty license;

  /**
    Evaluate a license expression for a given property name. The property must
    be defined as a boolean attribute of all licenses passed.

    # Inputs

    `name`
    : Name of the Attribute which should be checked

    `permissive`
    : Whether to apply checks permissive or reciprocal

    `license`
    : License expression which should be evaluated

    # Type

    ```
    evaluateNamedProperty :: String -> Bool -> AttrSet -> Bool
    ```

    # Example
    :::{.example}
    ## `lib.licenses.evaluateNamedProperty` usage example

    ```nix
    evaluateNamedProperty "deprecated" true (with lib.licenses; AND [ ncsa (WITH asl20 llvm-exception) ])
    => false
    ```
  */
  evaluateNamedProperty =
    name: permissive:
    let
      OR = if permissive then any else all;
      AND = if permissive then all else any;
      evaluateComplexProperty = handleComplexProperty (evaluateNamedProperty name permissive) AND OR;
    in
    license:
    if license.licenseType == "simple" then license.${name} else evaluateComplexProperty license;

  /**
    Check whether a license expression is free.

    # Inputs

    `license`
    : License expression which should be evaluated

    # Type

    ```
    isFree :: AttrSet -> Bool
    ```

    # Example
    :::{.example}
    ## `lib.licenses.isFree` usage example

    ```nix
    isFree (with lib.licenses; (AND [ ncsa (WITH asl20 llvm-exception) ]))
    => true
    ```
  */
  isFree = evaluateNamedProperty "free" true;

  /**
    Check whether a license expression is redistributable.

    # Inputs

    `license`
    : License expression which should be evaluated

    # Type

    ```
    isRedistributable :: AttrSet -> Bool
    ```

    # Example
    :::{.example}
    ## `lib.licenses.isRedistributable` usage example

    ```nix
    isRedistributable (with lib.licenses; (AND [ ncsa (WITH asl20 llvm-exception) ]))
    => true
    ```
  */
  isRedistributable = evaluateNamedProperty "redistributable" true;

  /**
    Check whether any of the given licenses is required in the license expression.

    # Inputs

    `licenses`
    : List of licenses which are tested

    `license`
    : License expression which should be evaluated

    # Type

    ```
    containsLicenses :: [AttrSet] -> AttrSet -> Bool
    ```

    # Example
    :::{.example}
    ## `lib.licenses.containsLicenses` usage example

    ```nix
    containsLicenses [ lib.licenses.asl20 ] (with lib.licenses; (AND [ ncsa (WITH asl20 llvm-exception) ]))
    => true
    ```
  */
  containsLicenses = licenses: evaluateProperty (x: elem x licenses) false;

  /**
    Convert a license expression to an SPDX license expression string.

    # Inputs

    `license`
    : License expression which to convert to an spdx expression

    # Type

    ```
    toSPDX :: AttrSet -> String
    ```

    # Example
    :::{.example}
    ## `lib.licenses.toSPDX` usage example

    ```nix
    toSPDX (with lib.licenses; AND [ ncsa (WITH asl20 llvm-exception) ])
    => "NCSA AND (Apache-2.0 WITH LLVM-exception)"
    ```
  */
  toSPDX =
    license:
    let
      mkBracket =
        x:
        if x.licenseType == "compound" || x.licenseType == "exception" then "(${toSPDX x})" else toSPDX x;
    in
    if license.licenseType == "simple" then
      license.spdxId or "LicenseRef-nixos-${license.shortName}"
    else if license.licenseType == "compound" then
      lib.concatMapStringsSep " ${license.operator} " (x: mkBracket x) license.licenses
    else if license.licenseType == "exception" then
      "${mkBracket license.license} ${license.operator} ${mkBracket license.exception}"
    else if license.licenseType == "plus" then
      "${mkBracket license.license}${license.operator}"
    else
      throw "Unknown license type";
}
