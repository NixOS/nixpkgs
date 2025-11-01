{ lib }:

let
  inherit (lib)
    isAttrs
    isDerivation
    isFunction
    isList
    mapAttrs
    removeAttrs
    warn
    ;
in
rec {
  /**
    Raise warning on an arbitrary value, when it is accessed
    and alias it to something else.

    # Inputs

    `msg`
    : The warning message to emit (via `lib.warn`).

    `v`
    : The value to wrap. Can be derivation/attribute set/function/list.

    # Examples
    :::{.example}
    ## `lib.derivations.warnAlias` usage example

    ```nix
    {
      myFunc = warnAlias "myFunc has been renamed to my-func" my-func;
    }
    ```

    :::
  */
  warnAlias =
    msg: v:
    if isDerivation v then
      warnOnInstantiate msg v
    else if isAttrs v then
      mapAttrs (_: warn msg) v
    else if isFunction v then
      arg: warn msg (v arg)
    else if isList v then
      map (warn msg) v
    else
      # Can’t do better than this, and a `throw` would be more
      # disruptive for users…
      #
      # `nix search` flags up warnings already, so hopefully this won’t
      # make things much worse until we have proper CI for aliases,
      # especially since aliases of paths and numbers are presumably
      # not common.
      warn msg v;

  /**
    Wrap a derivation such that instantiating it produces a warning.

    All attributes will be wrapped with `lib.warn` except from `.meta`, `.name`,
    and `.type` which are used by `nix search`, and `.outputName` which avoids
    double warnings with `nix-instantiate` and `nix-build`.

    # Inputs

    `msg`
    : The warning message to emit (via `lib.warn`).

    `drv`
    : The derivation to wrap.

    # Examples
    :::{.example}
    ## `lib.derivations.warnOnInstantiate` usage example

    ```nix
    {
      myPackage = warnOnInstantiate "myPackage has been renamed to my-package" my-package;
    }
    ```

    :::
  */
  warnOnInstantiate =
    msg: drv:
    let
      drvToWrap = removeAttrs drv [
        "meta"
        "name"
        "type"
        "outputName"
      ];
    in
    drv // mapAttrs (_: lib.warn msg) drvToWrap;
}
