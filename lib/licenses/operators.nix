{
  /**
    This should be used when there is a choice of which license expression to use.
    This is a disjunctive binary "OR" operator.

    # Inputs

    `licenses`
    : Possible licenses to choose from

    # Type

    ```
    OR :: [AttrSet] -> AttrSet
    ```

    # Example
    :::{.example}
    ## `lib.licenses.OR` usage example

    ```nix
    OR [ lib.licenses.mit lib.licenses.asl20 ]
    => { licenseType = "compound"; operator = "OR"; licenses = [ lib.licenses.mit lib.licenses.asl20 ] };
    ```
  */
  OR = licenses: {
    licenseType = "compound";
    operator = "OR";
    inherit licenses;
  };

  /**
     Create a compound license where the user needs to follow both licenses,
     equivalent to the SPDX `AND` modifier.

    # Inputs

    `licenses`
    : Licenses required to use

    # Type

    ```
    AND :: [AttrsSet] -> AttrSet
    ```

    # Example
    :::{.example}
    ## `lib.licenses.AND` usage example

    ```nix
    AND [ lib.licenses.mit lib.licenses.asl20 ]
    => { licenseType = "compound"; operator = "AND"; licenses = [ lib.licenses.mit lib.licenses.asl20 ] };
    ```
  */
  AND = licenses: {
    licenseType = "compound";
    operator = "AND";
    inherit licenses;
  };

  /**
     Create a license in which an exception has been applied,
     equivalent to the SPDX `WITH` modifier.

    # Inputs

    `license`
    : License to which the exception applies

    `exception`
    : Exception to apply

    # Type

    ```
    WITH :: AttrSet -> AttrSet -> AttrSet
    ```

    # Example
    :::{.example}
    ## `lib.licenses.WITH` usage example

    ```nix
    WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException
    => { licenseType = "exception"; operator = "WITH"; license = lib.licenses.lgpl21Only; exception = lib.licenses.ocamlLgplLinkingException; };
    ```
  */
  WITH = license: exception: {
    licenseType = "exception";
    operator = "WITH";
    inherit license exception;
  };

  /**
     Create a licenses which can be upgraded to any later version of itself,
     equivalent to the SPDX `+` modifier.
     This should not be applied to GPL licenses.

    # Inputs

    `license`
    : License to which apply an exception

    # Type

    ```
    PLUS :: AttrSet -> AttrSet
    ```

    # Example
    :::{.example}
    ## `lib.licenses.PLUS` usage example

    ```nix
    PLUS lib.licenses.eupl11
    => { licenseType = "plus"; operator = "+"; license = lib.licenses.eupl11; };
    ```
  */
  PLUS = license: {
    licenseType = "plus";
    operator = "+";
    inherit license;
  };
}
