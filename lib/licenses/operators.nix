{
  /**
    This should be used when there is a choice of which license expression to use.
    This is a disjunctive binary "OR" operator.

    # Example

    ```nix
    OR [ lib.licenses.mit lib.licenses.asl20 ]
    => { licenseType = "compound"; operator = "OR"; licenses = [ lib.licenses.mit lib.licenses.asl20 ] };
    ```

    # Type

    ```
    OR :: List -> AttrSet
    ```

    # Arguments

    - [licenses] Possible licenses to chose from
  */
  OR = licenses: {
    licenseType = "compound";
    operator = "OR";
    inherit licenses;
  };

  /**
     Create a compound licenses where the user needs to follow both licenses,
     eqivialent of spdx `and` modifier.

    # Example

    ```nix
    AND [ lib.licenses.mit lib.licenses.asl20 ]
    => { licenseType = "compound"; operator = "AND"; licenses = [ lib.licenses.mit lib.licenses.asl20 ] };
    ```

    # Type

    ```
    AND :: List -> AttrSet
    ```

    # Arguments

    - [licenses] Licenses required to use
  */
  AND = licenses: {
    licenseType = "compound";
    operator = "AND";
    inherit licenses;
  };

  /**
     Create a licenses exception where a license has a license exception,
     eqivialent of spdx `with` modifier.

    # Example

    ```nix
    WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException
    => { licenseType = "exception"; operator = "WITH"; license = lib.licenses.lgpl21Only; exception = lib.licenses.ocamlLgplLinkingException; };
    ```

    # Type

    ```
    WITH :: AttrSet -> AttrSet -> AttrSet
    ```

    # Arguments

    - [license] License to wich apply an exception
    - [exception] Exception to apply
  */
  WITH = license: exception: {
    licenseType = "compound";
    operator = "WITH";
    inherit license exception;
  };

  /**
     Create a licenses which can be upgraded to any later version of itself,
     eqivialent of spdx `+` modifier

    # Example

    ```nix
    PLUS lib.licenses.lgpl21Only
    => { licenseType = "plus"; operator = "+"; license = lib.licenses.lgpl21Only; };
    ```

    # Type

    ```
    WITH :: AttrSet -> AttrSet
    ```

    # Arguments

    - [license] License to wich apply an exception
  */
  PLUS = license: {
    licenseType = "plus";
    operator = "+";
    inherit license;
  };
}
