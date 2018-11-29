{ lib }:

# TODO say what monoid is I suppose

{

  list = {
    identity = [];
    append = lib.trivial.concat;
  };

  attrset = {
    identity = {};
    append = lib.trivial.mergeAttrs;
  };

  # Monoidally left-fold a list. The monoid's `append` and `identity` become the
  # other arguments besides the list to the `foldl`.
  fold = { identity, append, ... }: lib.foldl append identity;

}
