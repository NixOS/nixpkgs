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

}
