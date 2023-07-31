{ lib }:

let
  inherit (lib)
    concatStringsSep
    filterAttrs
    getDerivationsChildStrict
    isAttrs
    isDerivation
    mapAttrs
    throwIfNot
    ;
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

  /*
    getDerivationsChildStrict :: attrs -> (let tree = either package (attrsOf tree); in tree)

    NOTE: This function evaluates too much and should usually be avoided.

    Traverses a potentially nested attribute set of derivations and
    non-derivations in approximately the way `nix-build` would.
    Notably, this does not take into account restrictions on the attribute name.

    "Child strict" refers to an unfortunate but required property of this function.
    In order to determine whether any attribute should be returned at all, it must
    evaluate the value of the attribute.
    This lack of laziness is a performance risk, so it is best to specify your
    packages and package sets in a way that does not require this function.

    The `recurseForDerivations` attribute gets removed from the returned tree,
    as it does not contain a derivation, or any information that can't be
    recovered from `(attrs.type or null) == "derivation"`.
  */
  getDerivationsChildStrict = v0:
    if isDerivation v0
    then v0
    else
      lib.concatMapAttrs
        (k: v:
          if isDerivation v
          then { ${k} = v; }
          else if v.recurseForDerivations or false
          then { ${k} = mapAttrs (k: lib.getDerivationsChildStrict) (filterAttrs (k: isAttrs) v); }
          else { }
        )
        v0;

  /*
    `joinDerivationsLeafStrictSep <sep> <v>` turns the tree of derivations `<v>`
    into an attribute set of derivations.

    NOTE: This function evaluates too much and should usually be avoided.
          Specifically it always evaluates all the packages (leaves), even if
          only a single package was needed. See `getDerivationsChildStrict`.

          A better alternative is to use `//` and perhaps `lib.mapAttrs'` to
          rename or prefix the attributes.

    If the root of the tree is a derivation, the attribute name `default` will
    be used.

    If the derivation is one attribute deep, the attribute path is trivially
    an attribute name. If the derivation is at least one level deep, the
    function `concatStringsSep <sep>` is used to create the path name.

    If an attribute in `<v>` collides with a generated attribute name, the
    attribute in the original `<v>` wins.
  */
  joinDerivationsLeafStrictSep = sep: v:
    let
      isLeaf = _path: isDerivation;
      joinPath = path:
        if path == []
        then "default"
        else concatStringsSep sep path;
    in
      lib.joinAttrsRecursive
        joinPath
        isLeaf
        (getDerivationsChildStrict v);
}
