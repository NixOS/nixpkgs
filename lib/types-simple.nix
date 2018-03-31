# A simple type system to check plain nix values
# and get detailed error messages on type mismatch.
#
# Contains support for
# scalars (simple values)
# recursive types (lists of t and attrs of t)
# products (attribute sets with named fields)
# sums (tagged unions where you can match on the different cases)
# unions (untagged unions of the specified types)
# We can’t type functions (lambda expressions). Maybe in the future.
#
# What is the difference to `./types.nix`? / Why another type system?
#
# `./types.nix` is deeply entangled with the module system,
# in order to use it on plain nix values, you have to invoke the
# module system, which is pretty heavyweight and hard/verbose to do.
# Contrary to popular opinion, the `check` functions on module types
# does *not* do a recursive check for complex types/values.
# Plus, it is not possible to catch a type error, since the module
# system always instantly aborts nix evaluation on type error.
# The `checkType` function in this module returns a detailed,
# structured # error for each part of the substructure that
# does not match the given expected type.
# Concerning expressibility, an attrset with fixed fields can
# be given as easy as `product { field1 = type; … }`, whereas
# in `./types.nix` you need to use the complictated `submodule`
# mechanism. We also support tagged unions (`./types.nix` does not)
# and untagged unions of an arbitrary set of types (can be emulated
# with nested `either`s in `./types.nix`).
#
# In short: if you want to check a module option, use `./types.nix`.
# If you want to check a plain (possibly complex) nix value,
# use this module.
#
# The main function is `checkType`.
# Tests can be found in './tests/types-simple.nix`.

{ lib }:
let

  # The type functor.
  # t is the recursion “not yet inserted”.
  #
  # data Type t
  #   = Scalar
  #   | Recursive (Rec t)
  #   | Sum (Map String t)
  #   | Product (Map String t)
  #   | Union (List t)
  #  deriving (Functor)
  #
  # Fix Type is every t replaced with Type, recursively.

  # The alternatives above are tagged manually, by this variant enum:
  variants = {
    scalar = 0;
    recursive = 1;
    sum = 2;
    product = 3;
    union = 4;
  };

  ## -- HELPERS --

  unreachable = abort "should not be reached";

  # Functor instance of Type
  # fmap :: (a -> b) -> (Type a) -> (Type b)
  # it just applies a function over the “holes” in Type variants
  fmap = f: t:
         if t.variant == variants.scalar    then t
    else if t.variant == variants.recursive then
      t // { nested = f t.nested; }
    else if t.variant == variants.sum       then
      t // { alts   = lib.mapAttrs (lib.const f) t.alts; }
    else if t.variant == variants.product   then
      t // { opt = lib.mapAttrs (lib.const f) t.opt;
             req = lib.mapAttrs (lib.const f) t.req; }
    else if t.variant == variants.union     then
      t // { altList = map f t.altList; }
    else unreachable;

  # cata :: (Type a -> a) -> Fix Type -> a
  # collapses the structure Fix Type (nested types) into an a,
  # by collapsing one layer at a time with the function (/algebra)
  # alg :: (Type a -> a)
  cata = alg: t: alg (fmap (cata alg) t);


  ## -- MAIN --

  # Main type checking function.
  # Example:
  # > checkType (list string) [ "foo" "bar" ]
  # { }
  # > checkType (list string) [ "foo" 42 ]
  # { "1" = { should = "string"; val = 42; }; }
  #
  # checkType :: Fix Type -> Value -> (Nested Attrs) Errors
  #
  # where { } means no error (the given value is of the given type)
  # and { should : String, val : Value } denotes a type mismatch.
  checkType =
    let
      # the type check suceeded
      ok = {};
      # filters out non-error messages
      mapAndFilter = f: vals:
        lib.filterAttrs (_: v: v != {}) (lib.mapAttrs f vals);
      # alg :: Type (Value -> Errors) -> (Value -> Errors)
      alg = t: v:
            # the main type check on each “level”
            # the cases further down handle the differences
            # between the variants (poor man’s pattern matching)
            # TODO: some errors should throw some more context.
            # e.g. putting more than one field in a sum value
            if !(t.check v) then { should = t.description; val = v; }
        # scalars have just one level (already checked above)
        else if t.variant == variants.scalar    then ok
        # grab all child values and type check them one by one
        else if t.variant == variants.recursive then
          mapAndFilter (_: el: t.nested el) (t.each v)
        # there’s exactly one tagged value, so check that
        else if t.variant == variants.sum       then
              # we already tested length == 1 in .check
          let alt = builtins.head (builtins.attrNames v);
          in t.alts.${alt} v.${alt}
        # check each field according to its type
        # optional missing fields of course always pass the check
        else if t.variant == variants.product   then
          mapAndFilter (n: f: if v ? ${n} then f v.${n} else ok)
                       (t.req // t.opt)
        # if the value fails the check for each type it can have,
        # we throw an error; if one check succeeds the union is satisfied
        else if t.variant == variants.union     then
          # unions are awkward, the type checker can’t do much here
          if lib.all (res: res != ok) (map (f: f v) t.altList)
          then { should = t.description; val = v; }
          else ok
        else unreachable;
    # cata only has “two arguments”, giving it a Value as third
    # argument “morphs” the `a` in alg to (Value -> Errors);
    # of course we could curry t and v away,
    # but just `cata alg` would be very confusing ;)
    in t: v: cata alg t v;


  ## -- TYPE SETUP STUFF --

  mkBaseType = {
    # unique name (for matching on the type)
    name,
    # the (displayable) type description
    description,
    # a function to check the outermost type, given a value (Val -> Bool)
    check,
    # the variant of this type
    variant,
    # extra fields belonging to the variant
    extraFields
  }: { inherit name description check variant; } // extraFields;

  mkScalar = { name, description, check }: mkBaseType {
    inherit name description check;
    variant = variants.scalar;
    extraFields = {};
  };

  mkRecursive = { name, description, check,
    # return all children for a value of this type T t,
    # give each child (of type t) a displayable name.
    # (T t -> Map Name t)
    each,
    # The nested value t of the type functor
    nested
  }: mkBaseType {
    inherit name description check;
    variant = variants.recursive;
    extraFields = { inherit each nested; };
  };


  ## -- TYPES --

  # the type with no inhabitants (kind of useless …)
  void = mkScalar {
    name = "void";
    description = "void";
    # there are no values of type void
    check = lib.const false;
  };

  # the any type, every value is an inhabitant
  # it basically turns off the type system, use with care
  any = mkScalar {
    name = "any";
    description = "any type";
    check = lib.const true;
  };

  # the type with exactly one inhabitant
  unit = mkScalar {
    name = "unit";
    description = "unit";
    # there is exactly one unit value, we represent it with {}
    # Q: why not `null`?
    # A: `null` has strong connotations as the “always existing”
    # alternative value; of course in a unityped language like
    # nix this is moot, but here we take the chance to throw out
    # this harmful idea (the “million dollar mistake”).
    check = v: v == {};
  };

  # the type with two inhabitants
  bool = mkScalar {
    name = "bool";
    description = "boolean";
    check = builtins.isBool;
  };

  # a nix string
  string = mkScalar {
    name = "string";
    description = "string";
    check = builtins.isString;
  };

  # a signed nix integer
  int = mkScalar {
    name = "int";
    description = "integer";
    check = builtins.isInt;
  };

  # a nix floating point number
  float = mkScalar {
    name = "float";
    description = "float";
    check = builtins.isFloat;
  };

  # helper for descriptions of recursive types
  # TODO: descriptions need to assume t is a type,
  # which is only true for Fix Type. How to make nice?
  describe = t: t.description or "<non-type>";

  # list with children of type t
  # list bool:
  #   [ true false false ]
  # list (attrs unit):
  #   [ { a = {}; } { b = {}; } ]
  #   []
  list = t: mkRecursive {
    name = "list";
    description = "list of ${describe t}";
    check = builtins.isList;
    # each child gets named by its index, starting from 0
    each = l: builtins.listToAttrs
      (lib.imap0 (i: v: lib.nameValuePair (toString i) v) l);
    nested = t;
  };

  # attrset with children of type t
  # attrs int: { foo = 23; bar = 42; }
  # attrs (attrs string):
  #  { foo.bar = "hello"; baz.quux = "x"; }
  #  { x = { y = "wow"; }; }
  attrs = t: mkRecursive {
    name = "attrs";
    description = "attrset of ${describe t}";
    check = builtins.isAttrs;
    each = lib.id;
    nested = t;
  };

  # TODO: nonempty list and attrs

  # product type with fields of the specified types
  # product { x = int; y = unit; }:
  #   { x = 23; y = {}; }
  #   { x = 42; y = {}; }
  # product {}: <- yeah, that’s isomorphic to unit
  #   { }
  # product { foo = void; }:
  #   just kidding. :)
  product = fields: productOpt { req = fields; opt = {}; };

  # product type with the possibility of optional fields
  # actually the more generic type of product, BUT:
  # code with a fixed number of fields is less brittle.
  # choose wisely.
  # productOpt { req = {}; opt = { a = unit; b = int; }:
  #   { }
  #   { a = {}; }
  #   { a = {}; b = 23; }
  # if a product is `open`, any fields that are not
  # given a type in either `req` or `opt` will default
  # to type `any` (that is they typecheck by default).
  # productOpt { req = { a = int; }; opt = {}; open = true; }
  #   { a = 23; }
  #   { a = 42; b = "foo"; c = false; }
  productOpt = { req, opt, open ? false }: mkBaseType {
    name = "product";
    description = "{ " +
      lib.concatStringsSep ", "
        (  lib.mapAttrsToList (n: t: "${n}: ${describe t}") req
        ++ lib.mapAttrsToList (n: t: "[${n}: ${describe t}]") opt
        # TODO: maybe but this at the beginning: [ …,
        # so that it’s easier to see that an attrset is open
        ++ lib.optional open "…")
      + " }";
    check = v:
      let reqfs = builtins.attrNames req;
          optfs = builtins.attrNames opt;
          vfs   = builtins.attrNames v;
      in lib.foldl lib.and (builtins.isAttrs v) [
      # if there’s only required fields, this is an optimization
        (opt == {} && !open -> reqfs == vfs)
        # all required fields have to exist in the value
        # reqfs - vfs
        (lib.subtractLists vfs reqfs == [])
        # whithout req, and if the product is not open
        # only opt fields must be in the value
        # (vfs - reqfs) - otfs
        (!open -> [] == lib.subtractLists optfs
                          (lib.subtractLists reqfs vfs))
      ];
    variant = variants.product;
    extraFields = {
      inherit opt req;
    };
  };

  # sum type with alternatives of the specified types
  # sum { left = string; right = bool; }:
  #   { left = "work it"; }
  #   { right = false; }
  # sum { true = unit; false = unit; } <- that’s isomorphic to bool
  #   { true = {}; }
  #   { false = {}; }
  # sum { X = product { name = string; age = int; }; Y = list unit; }
  #   { X = { name = "peter shaw"; age = 22; }; }
  #   { Y = [ {} {} {} {} {} {} {} {} ]; }
  sum = alts: assert alts != {}; mkBaseType {
    name = "sum";
    description = "< " +
      lib.concatStringsSep " | "
        (lib.mapAttrsToList (n: t: "${n}: ${describe t}") alts)
      + " >";
    check = v:
      let alt = builtins.attrNames v;
      in builtins.isAttrs v
      # exactly one of the alts has to be used by the value
      && builtins.length alt == 1
      # the alt tag of the value should of course be a possibility
      && alts ? ${lib.head alt};
    variant = variants.sum;
    extraFields = {
      inherit alts;
    };
  };

  # untagged union type
  # ATTENTION: this leads to *bad* type checker errors in practice,
  # you also can’t do pattern matching; use sum if possible.
  # union [ bool int ]
  #   3
  #   true
  # list (union [ int string ])
  #   [ "foo" 34 "bar" ]
  # please don’t use this.
  union = altList: assert altList != []; mkBaseType {
    name = "union";
    description = "one of [ "
      + lib.concatMapStringsSep ", " describe altList
      + " ]";
    # any type that checks out is fine
    check = v: lib.any (t: t.check v) altList;
    variant = variants.union;
    extraFields = {
    inherit altList;
  };
  };

  # restrict applies a further check to values of type
  # the idea is simple, but some crazy things are possible, like
  # * even integers
  # * integers between 23 and 42
  # * enumerations
  # * lists with exactly three elements where the second is the string "bla"
  # type errors from the base type checks are retained.
  #
  # restrict { type = int; check = isEven; … }:
  #   2
  #   42
  # see tests for further examples
  restrict = {
    # type that should be restricted
    type,
    # takes a value of type
    # return true for values of type that are valid
    check,
    # the (displayable) restricted type description
    description
  }: type // {
    inherit description;
    # first the general type is checked,
    # then the restriction check is tried
    # this way the restriction check can assume the correct type
    check = v: type.check v && check v;
  };

  # TODO: should scalars be allowed as nest types?
  # TODO: how to implement?
  # nested = nest: t: mkBaseType {
  #   description = "nested ${describe nest} of ${describe t}";
  #   check = nest.check ;
  #   variant = nest.variant;
  #   extraFields = {


  ## -- FUNCTIONS --

  # TODO: pattern match function
  # match =

  # Feed it the output of checkType (after testing for success (== {})
  # and it returns a more or less pretty string of errors.
  prettyPrintErrors =
    let
      isLeaf = v: {} == checkType (product { should = string; val = any; }) v;
      recurse = path: errs:
        if isLeaf errs
        then [{ inherit path; inherit (errs) should val; }]
        else builtins.concatLists (lib.mapAttrsToList
          (p: errs': recurse (path ++ [p]) errs') errs);
      pretty = { path, should, val }:
        "${lib.concatStringsSep "." path} should be: ${
          should}\nbut is: ${lib.generators.toPretty {} val}";
    in errs: lib.concatMapStringsSep "\n" pretty (recurse [] errs);

in {
  # The type of nix types, as non-recursive functor.
  # fmap and cata are specialized to Type.
  Type = { inherit variants fmap cata; };
  # Constructor functions for types.
  # Their internal structure/fields are an *implementation detail*.
  inherit void any unit bool string int float
          list attrs product productOpt sum union
          restrict;
  # Type checking.
  inherit checkType;
  # Functions.
  inherit prettyPrintErrors;
}
