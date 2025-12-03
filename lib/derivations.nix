{ lib }:

let
  inherit (lib)
    genAttrs
    isString
    mapAttrs
    removeAttrs
    throwIfNot
    ;

  showMaybeAttrPosPre =
    prefix: attrName: v:
    let
      pos = builtins.unsafeGetAttrPos attrName v;
    in
    if pos == null then "" else "${prefix}${pos.file}:${toString pos.line}:${toString pos.column}";

  showMaybePackagePosPre =
    prefix: pkg:
    if pkg ? meta.position && isString pkg.meta.position then "${prefix}${pkg.meta.position}" else "";
in
{
  /**
    Restrict a derivation to a predictable set of attribute names, so
    that the returned attrset is not strict in the actual derivation,
    saving a lot of computation when the derivation is non-trivial.

    This is useful in situations where a derivation might only be used for its
    passthru attributes, improving evaluation performance.

    The returned attribute set is lazy in `derivation`. Specifically, this
    means that the derivation will not be evaluated in at least the
    situations below.

    For illustration and/or testing, we define derivation such that its
    evaluation is very noticeable.

        let derivation = throw "This won't be evaluated.";

    In the following expressions, `derivation` will _not_ be evaluated:

        (lazyDerivation { inherit derivation; }).type

        attrNames (lazyDerivation { inherit derivation; })

        (lazyDerivation { inherit derivation; } // { foo = true; }).foo

        (lazyDerivation { inherit derivation; meta.foo = true; }).meta

    In these expressions, `derivation` _will_ be evaluated:

        "${lazyDerivation { inherit derivation }}"

        (lazyDerivation { inherit derivation }).outPath

        (lazyDerivation { inherit derivation }).meta

    And the following expressions are not valid, because the refer to
    implementation details and/or attributes that may not be present on
    some derivations:

        (lazyDerivation { inherit derivation }).buildInputs

        (lazyDerivation { inherit derivation }).passthru

        (lazyDerivation { inherit derivation }).pythonPath

    # Inputs

    Takes an attribute set with the following attributes

    `derivation`
    : The derivation to be wrapped.

    `meta`
    : Optional meta attribute.

      While this function is primarily about derivations, it can improve
      the `meta` package attribute, which is usually specified through
      `mkDerivation`.

    `passthru`
    : Optional extra values to add to the returned attrset.

      This can be used for adding package attributes, such as `tests`.

    `outputs`
    : Optional list of assumed outputs. Default: `[ "out" ]`

      This must match the set of outputs that the returned derivation has.
      You must use this when the derivation has multiple outputs.
  */
  lazyDerivation =
    args@{
      derivation,
      meta ? null,
      passthru ? { },
      outputs ? [ "out" ],
    }:
    let
      # These checks are strict in `drv` and some `drv` attributes, but the
      # attrset spine returned by lazyDerivation does not depend on it.
      # Instead, the individual derivation attributes do depend on it.
      checked =
        throwIfNot (derivation.type or null == "derivation") "lazyDerivation: input must be a derivation."
          throwIfNot
          # NOTE: Technically we could require our outputs to be a subset of the
          # actual ones, or even leave them unchecked and fail on a lazy basis.
          # However, consider the case where an output is added in the underlying
          # derivation, such as dev. lazyDerivation would remove it and cause it
          # to fail as a buildInputs item, without any indication as to what
          # happened. Hence the more stringent condition. We could consider
          # adding a flag to control this behavior if there's a valid case for it,
          # but the documentation must have a note like this.
          (derivation.outputs == outputs)
          ''
            lib.lazyDerivation: The derivation ${derivation.name or "<unknown>"} has outputs that don't match the assumed outputs.

            Assumed outputs passed to lazyDerivation${showMaybeAttrPosPre ",\n    at " "outputs" args}:
                ${lib.generators.toPretty { multiline = false; } outputs};

            Actual outputs of the derivation${showMaybePackagePosPre ",\n    defined at " derivation}:
                ${lib.generators.toPretty { multiline = false; } derivation.outputs}

            If the outputs are known ahead of evaluating the derivation,
            then update the lazyDerivation call to match the actual outputs, in the same order.
            If lazyDerivation is passed a literal value, just change it to the actual outputs.
            As a result it will work as before / as intended.

            Otherwise, when the outputs are dynamic and can't be known ahead of time, it won't
            be possible to add laziness, but lib.lazyDerivation may still be useful for trimming
            the attributes.
            If you want to keep trimming the attributes, make sure that the package is in a
            variable (don't evaluate it twice!) and pass the variable and its outputs attribute
            to lib.lazyDerivation. This largely defeats laziness, but keeps the trimming.
            If none of the above works for you, replace the lib.lazyDerivation call by the
            expression in the derivation argument.
          ''
          derivation;
    in
    {
      # Hardcoded `type`
      #
      # `lazyDerivation` requires its `derivation` argument to be a derivation,
      # so if it is not, that is a programming error by the caller and not
      # something that `lazyDerivation` consumers should be able to correct
      # for after the fact.
      # So, to improve laziness, we assume correctness here and check it only
      # when actual derivation values are accessed later.
      type = "derivation";

      # A fixed set of derivation values, so that `lazyDerivation` can return
      # its attrset before evaluating `derivation`.
      # This must only list attributes that are available on _all_ derivations.
      inherit (checked)
        outPath
        outputName
        drvPath
        name
        system
        ;
      inherit outputs;

      # The meta attribute can either be taken from the derivation, or if the
      # `lazyDerivation` caller knew a shortcut, be taken from there.
      meta = args.meta or checked.meta;
    }
    // genAttrs outputs (outputName: checked.${outputName})
    // passthru;

  /**
    Conditionally set a derivation attribute.

    Because `mkDerivation` sets `__ignoreNulls = true`, a derivation
    attribute set to `null` will not impact the derivation output hash.
    Thus, this function passes through its `value` argument if the `cond`
    is `true`, but returns `null` if not.

    # Inputs

    `cond`

    : Condition

    `value`

    : Attribute value

    # Type

    ```
    optionalDrvAttr :: Bool -> a -> a | Null
    ```

    # Examples
    :::{.example}
    ## `lib.derivations.optionalDrvAttr` usage example

    ```nix
    (stdenv.mkDerivation {
      name = "foo";
      x = optionalDrvAttr true 1;
      y = optionalDrvAttr false 1;
    }).drvPath == (stdenv.mkDerivation {
      name = "foo";
      x = 1;
    }).drvPath
    => true
    ```

    :::
  */
  optionalDrvAttr = cond: value: if cond then value else null;

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
