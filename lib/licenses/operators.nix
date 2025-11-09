{
  /**
     Create a compound licenses where the user can chose which licenses to use,
     eqivialent of spdx `or` modifier.

    # Example

    ```nix
    OR lib.licenses.mit lib.licenses.asl20
    => { type = "compound"; operator = "OR"; base = lib.licenses.mit; mod = lib.licenses.asl20; };
    ```

    # Type

    ```
    OR :: AttrSet -> AttrSet -> AttrSet
    ```

    # Arguments

    - [base] Possible license to chose from
    - [mod] Other possible license to chose from
  */
  OR = base: mod: {
    type = "compound";
    operator = "OR";
    inherit base mod;
  };

  /**
     Create a compound licenses where the user needs to follow both licenses,
     eqivialent of spdx `and` modifier.

    # Example

    ```nix
    AND lib.licenses.mit lib.licenses.asl20
    => { type = "compound"; operator = "AND"; base = lib.licenses.mit; mod = lib.licenses.asl20; };
    ```

    # Type

    ```
    AND :: AttrSet -> AttrSet -> AttrSet
    ```

    # Arguments

    - [base] License required to use
    - [mod] Second license required to use
  */
  AND = base: mod: {
    type = "compound";
    operator = "AND";
    inherit base mod;
  };

  /**
     Create a compound licenses where a license has a license exception,
     eqivialent of spdx `with` modifier.

    # Example

    ```nix
    WITH lib.licenses.lgpl21Only lib.licenses.ocamlLgplLinkingException
    => { type = "compound"; operator = "WITH"; base = lib.licenses.lgpl21Only; mod = lib.licenses.ocamlLgplLinkingException; };
    ```

    # Type

    ```
    WITH :: AttrSet -> AttrSet -> AttrSet
    ```

    # Arguments

    - [base] License to wich apply an exception
    - [mod] Exception to apply
  */
  WITH = base: mod: {
    type = "compound";
    operator = "WITH";
    inherit base mod;
  };
}
