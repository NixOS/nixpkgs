{ lib }:

let
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
      AND evaluateSubProperty [
        license.license
        license.exception
      ]
    else if license.licenseType == "plus" then
      evaluateSubProperty license.license
    else
      throw "Unknown license type or legacy license";
in
rec {
  /**
    Evaluate a license expression for a given predicate.

    # Example

    ```nix
    evaluateProperty (x: x.free) true (with lib.licenses; AND [ ncsa (WITH asl20 llvm-exception) ])
    ```
    # Type

    ```
    evaluateProperty :: Function -> Bool -> AttrSet -> Bool
    ```

    # Arguments

    - [predicate] checks for each license included in the license expression
    - [permissive] whether to apply checks permissive or reciprocal
    - [license] license expression to check
  */
  evaluateProperty =
    predicate: permissive:
    let
      OR = if permissive then lib.any else lib.all;
      AND = if permissive then lib.all else lib.any;
      evaluateComplexProperty = handleComplexProperty (evaluateProperty predicate permissive) AND OR;
    in
    license:
    if license.licenseType == "simple" then predicate license else evaluateComplexProperty license;

  /**
    Evaluate a license expression for a given property name. The property must
    be defined as a boolean attribute of all licenses passed.

    # Example

    ```nix
    evaluateNamedProperty "deprecated" true (with lib.licenses; AND [ ncsa (WITH asl20 llvm-exception) ])
    ```
    # Type

    ```
    evaluateProperty :: String -> Bool -> AttrSet -> Bool
    ```

    # Arguments

    - [name] name of the attribute to check
    - [permissive] whether to apply checks permissive or reciprocal
    - [license] license expression to check
  */
  evaluateNamedProperty =
    name: permissive:
    let
      OR = if permissive then lib.any else lib.all;
      AND = if permissive then lib.all else lib.any;
      evaluateComplexProperty = handleComplexProperty (evaluateNamedProperty name permissive) AND OR;
    in
    license:
    if license.licenseType == "simple" then license.${name} else evaluateComplexProperty license;

  /**
    Check whether a license expression is free.

    # Example

    ```nix
    isFree (with lib.licenses; (AND [ ncsa (WITH asl20 llvm-exception) ]))
    => true
    ```

    # Type

    ```
    isFree :: AttrSet -> Bool
    ```

    # Arguments

    - [license] License expression to check if free
  */
  isFree = evaluateNamedProperty "free" true;

  /**
    Check whether a license expression is redistributable.

    # Example

    ```nix
    isRedistributable (with lib.licenses; (AND [ ncsa (WITH asl20 llvm-exception) ]))
    => true
    ```

    # Type

    ```
    isRedistributable :: AttrSet -> Bool
    ```

    # Arguments

    - [license] License expression to check if redistributable
  */
  isRedistributable = evaluateNamedProperty "redistributable" true;

  /**
    Check whether any of the given licenses is required in the license expression.

    # Example

    ```nix
    containsLicenses [ lib.licenses.asl20 ] (with lib.licenses; (AND [ ncsa (WITH asl20 llvm-exception) ]))
    => true
    ```

    # Type

    ```
    containsLicenses :: List -> AttrSet -> Bool
    ```

    # Arguments

    - [licenses] List of licenses to look
    - [license] License expression to check
  */
  containsLicenses = licenses: evaluateProperty (x: lib.lists.elem x licenses) false;

  /**
    Convert a license expression to an SPDX license expression string.

    # Example

    ```nix
    toSPDX (with lib.licenses; AND [ ncsa (WITH asl20 llvm-exception) ])
    => "NCSA AND (Apache-2.0 WITH LLVM-exception)"
    ```

    # Type

    ```
    toSPDX :: AttrSet -> String
    ```

    # Arguments

    - [license] License expression which to convert to spdx expression
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
