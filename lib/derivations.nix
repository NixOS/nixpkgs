{ lib }:

let
  inherit (lib) throwIfNot;
in
{
  /*
    Restrict a derivation to a predictable set of attribute names, so
    that the returned attrset is not strict in the actual derivation,
    saving a lot of computation when the derivation is non-trivial.

    This is useful in situations where a derivation might only be used for its
    passthru attributes, improving evaluation performance.

    The returned attribute set is lazy in `derivation`. Specifically, this
    means that the derivation will not be evaluated in at least the
    situations below.

    For illustration and/or testing, we define derivation such that its
    evaluation is very noticable.

        let derivation = throw "This won't be evaluated.";

    In the following expressions, `derivation` will _not_ be evaluated:

        (lazyDerivation { inherit derivation; }).type

        attrNames (lazyDerivation { inherit derivation; })

        (lazyDerivation { inherit derivation; } // { foo = true; }).foo

        (lazyDerivation { inherit derivation; meta.foo = true; }).meta

    In these expressions, it `derivation` _will_ be evaluated:

        "${lazyDerivation { inherit derivation }}"

        (lazyDerivation { inherit derivation }).outPath

        (lazyDerivation { inherit derivation }).meta

    And the following expressions are not valid, because the refer to
    implementation details and/or attributes that may not be present on
    some derivations:

        (lazyDerivation { inherit derivation }).buildInputs

        (lazyDerivation { inherit derivation }).passthru

        (lazyDerivation { inherit derivation }).pythonPath

  */
  lazyDerivation =
    args@{
      # The derivation to be wrapped.
      derivation
    , # Optional meta attribute.
      #
      # While this function is primarily about derivations, it can improve
      # the `meta` package attribute, which is usually specified through
      # `mkDerivation`.
      meta ? null
    , # Optional extra values to add to the returned attrset.
      #
      # This can be used for adding package attributes, such as `tests`.
      passthru ? { }
    }:
    let
      # These checks are strict in `drv` and some `drv` attributes, but the
      # attrset spine returned by lazyDerivation does not depend on it.
      # Instead, the individual derivation attributes do depend on it.
      checked =
        throwIfNot (derivation.type or null == "derivation")
          "lazySimpleDerivation: input must be a derivation."
          throwIfNot
          (derivation.outputs == [ "out" ])
          # Supporting multiple outputs should be a matter of inheriting more attrs.
          "The derivation ${derivation.name or "<unknown>"} has multiple outputs. This is not supported by lazySimpleDerivation yet. Support could be added, and be useful as long as the set of outputs is known in advance, without evaluating the actual derivation."
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
      inherit (checked) outputs out outPath outputName drvPath name system;

      # The meta attribute can either be taken from the derivation, or if the
      # `lazyDerivation` caller knew a shortcut, be taken from there.
      meta = args.meta or checked.meta;
    } // passthru;
}
