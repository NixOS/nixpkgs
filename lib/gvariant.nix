# This file is based on https://github.com/nix-community/home-manager
# Copyright (c) 2017-2022 Home Manager contributors
#


{ lib }:

/* A partial and basic implementation of GVariant formatted strings.
   See https://docs.gtk.org/glib/gvariant-format-strings.html for detauls.

   Note, this API is not considered fully stable and it might therefore
   change in backwards incompatible ways without prior notice.
*/
let
  inherit (lib)
    concatMapStringsSep concatStrings escape head replaceStrings;

  mkPrimitive = t: v: {
    _type = "gvariant";
    type = t;
    value = v;
    __toString = self: "@${self.type} ${toString self.value}"; # https://docs.gtk.org/glib/gvariant-text.html
  };

  type = {
    arrayOf = t: "a${t}";
    maybeOf = t: "m${t}";
    tupleOf = ts: "(${concatStrings ts})";
    dictionaryEntryOf = nameType: valueType: "{${nameType}${valueType}}";
    string = "s";
    boolean = "b";
    uchar = "y";
    int16 = "n";
    uint16 = "q";
    int32 = "i";
    uint32 = "u";
    int64 = "x";
    uint64 = "t";
    double = "d";
    variant = "v";
  };

  /* Check if a value is a GVariant value

     Type:
       isGVariant :: Any -> Bool
  */
  isGVariant = v: v._type or "" == "gvariant";

in
rec {

  inherit type isGVariant;

  /* Returns the GVariant value that most closely matches the given Nix value.
     If no GVariant value can be found unambiguously then error is thrown.

     Type:
       mkValue :: Any -> gvariant
  */
  mkValue = v:
    if builtins.isBool v then
      mkBoolean v
    else if builtins.isFloat v then
      mkDouble v
    else if builtins.isString v then
      mkString v
    else if builtins.isList v then
      mkArray v
    else if isGVariant v then
      v
    else
      throw "The GVariant type of ${v} can't be inferred.";

  /* Returns the GVariant array from the given type of the elements and a Nix list.

     Type:
       mkArray :: [Any] -> gvariant

     Example:
       # Creating a string array
       lib.gvariant.mkArray [ "a" "b" "c" ]
  */
  mkArray = elems:
    let
      vs = map mkValue (lib.throwIf (elems == [ ]) "Please create empty array with mkEmptyArray." elems);
      elemType = lib.throwIfNot (lib.all (t: (head vs).type == t) (map (v: v.type) vs))
        "Elements in a list should have same type."
        (head vs).type;
    in
    mkPrimitive (type.arrayOf elemType) vs // {
      __toString = self:
        "@${self.type} [${concatMapStringsSep "," toString self.value}]";
    };

  /* Returns the GVariant array from the given empty Nix list.

     Type:
       mkEmptyArray :: gvariant.type -> gvariant

     Example:
       # Creating an empty string array
       lib.gvariant.mkEmptyArray (lib.gvariant.type.string)
  */
  mkEmptyArray = elemType: mkPrimitive (type.arrayOf elemType) [ ] // {
    __toString = self: "@${self.type} []";
  };


  /* Returns the GVariant variant from the given Nix value. Variants are containers
     of different GVariant type.

     Type:
       mkVariant :: Any -> gvariant

     Example:
       lib.gvariant.mkArray [
         (lib.gvariant.mkVariant "a string")
         (lib.gvariant.mkVariant (lib.gvariant.mkInt32 1))
       ]
  */
  mkVariant = elem:
    let gvarElem = mkValue elem;
    in mkPrimitive type.variant gvarElem // {
      __toString = self: "<${toString self.value}>";
    };

  /* Returns the GVariant dictionary entry from the given key and value.

     Type:
       mkDictionaryEntry :: String -> Any -> gvariant

     Example:
       # A dictionary describing an Epiphany’s search provider
       [
         (lib.gvariant.mkDictionaryEntry "url" (lib.gvariant.mkVariant "https://duckduckgo.com/?q=%s&t=epiphany"))
         (lib.gvariant.mkDictionaryEntry "bang" (lib.gvariant.mkVariant "!d"))
         (lib.gvariant.mkDictionaryEntry "name" (lib.gvariant.mkVariant "DuckDuckGo"))
       ]
  */
  mkDictionaryEntry =
    # The key of the entry
    name:
    # The value of the entry
    value:
    let
      name' = mkValue name;
      value' = mkValue value;
      dictionaryType = type.dictionaryEntryOf name'.type value'.type;
    in
    mkPrimitive dictionaryType { inherit name value; } // {
      __toString = self: "@${self.type} {${name'},${value'}}";
    };

  /* Returns the GVariant maybe from the given element type.

     Type:
       mkMaybe :: gvariant.type -> Any -> gvariant
  */
  mkMaybe = elemType: elem:
    mkPrimitive (type.maybeOf elemType) elem // {
      __toString = self:
        if self.value == null then
          "@${self.type} nothing"
        else
          "just ${toString self.value}";
    };

  /* Returns the GVariant nothing from the given element type.

     Type:
       mkNothing :: gvariant.type -> gvariant
  */
  mkNothing = elemType: mkMaybe elemType null;

  /* Returns the GVariant just from the given Nix value.

     Type:
       mkJust :: Any -> gvariant
  */
  mkJust = elem: let gvarElem = mkValue elem; in mkMaybe gvarElem.type gvarElem;

  /* Returns the GVariant tuple from the given Nix list.

     Type:
       mkTuple :: [Any] -> gvariant
  */
  mkTuple = elems:
    let
      gvarElems = map mkValue elems;
      tupleType = type.tupleOf (map (e: e.type) gvarElems);
    in
    mkPrimitive tupleType gvarElems // {
      __toString = self:
        "@${self.type} (${concatMapStringsSep "," toString self.value})";
    };

  /* Returns the GVariant boolean from the given Nix bool value.

     Type:
       mkBoolean :: Bool -> gvariant
  */
  mkBoolean = v:
    mkPrimitive type.boolean v // {
      __toString = self: if self.value then "true" else "false";
    };

  /* Returns the GVariant string from the given Nix string value.

     Type:
       mkString :: String -> gvariant
  */
  mkString = v:
    let sanitize = s: replaceStrings [ "\n" ] [ "\\n" ] (escape [ "'" "\\" ] s);
    in mkPrimitive type.string v // {
      __toString = self: "'${sanitize self.value}'";
    };

  /* Returns the GVariant object path from the given Nix string value.

     Type:
       mkObjectpath :: String -> gvariant
  */
  mkObjectpath = v:
    mkPrimitive type.string v // {
      __toString = self: "objectpath '${escape [ "'" ] self.value}'";
    };

  /* Returns the GVariant uchar from the given Nix int value.

     Type:
       mkUchar :: Int -> gvariant
  */
  mkUchar = mkPrimitive type.uchar;

  /* Returns the GVariant int16 from the given Nix int value.

     Type:
       mkInt16 :: Int -> gvariant
  */
  mkInt16 = mkPrimitive type.int16;

  /* Returns the GVariant uint16 from the given Nix int value.

     Type:
       mkUint16 :: Int -> gvariant
  */
  mkUint16 = mkPrimitive type.uint16;

  /* Returns the GVariant int32 from the given Nix int value.

     Type:
       mkInt32 :: Int -> gvariant
  */
  mkInt32 = v:
    mkPrimitive type.int32 v // {
      __toString = self: toString self.value;
    };

  /* Returns the GVariant uint32 from the given Nix int value.

     Type:
       mkUint32 :: Int -> gvariant
  */
  mkUint32 = mkPrimitive type.uint32;

  /* Returns the GVariant int64 from the given Nix int value.

     Type:
       mkInt64 :: Int -> gvariant
  */
  mkInt64 = mkPrimitive type.int64;

  /* Returns the GVariant uint64 from the given Nix int value.

     Type:
       mkUint64 :: Int -> gvariant
  */
  mkUint64 = mkPrimitive type.uint64;

  /* Returns the GVariant double from the given Nix float value.

     Type:
       mkDouble :: Float -> gvariant
  */
  mkDouble = v:
    mkPrimitive type.double v // {
      __toString = self: toString self.value;
    };
}
