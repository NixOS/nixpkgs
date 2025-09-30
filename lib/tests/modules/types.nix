# Run with:
#   cd nixpkgs
#   ./lib/tests/modules.sh
{ lib, ... }:
let
  inherit (builtins)
    storeDir
    ;
  inherit (lib)
    types
    mkOption
    ;

in
{
  options = {
    pathInStore = mkOption { type = types.lazyAttrsOf types.pathInStore; };
    assertions = mkOption { };
  };
  config = {
    pathInStore.ok1 = "${storeDir}/0lz9p8xhf89kb1c1kk6jxrzskaiygnlh-bash-5.2-p15.drv";
    pathInStore.ok2 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15";
    pathInStore.ok3 = "${storeDir}/0fb3ykw9r5hpayd05sr0cizwadzq1d8q-bash-5.2-p15/bin/bash";
    pathInStore.bad1 = "";
    pathInStore.bad2 = "${storeDir}";
    pathInStore.bad3 = "${storeDir}/";
    pathInStore.bad4 = "${storeDir}/.links"; # technically true, but not reasonable
    pathInStore.bad5 = "/foo/bar";

    assertions =
      with lib.types;

      assert str.description == "string";
      assert int.description == "signed integer";
      assert (attrsOf str).description == "attribute set of string";
      assert (attrsOf (attrsOf str)).description == "attribute set of attribute set of string";
      assert
        (oneOf [
          (attrsOf str)
          int
          bool
        ]).description == "(attribute set of string) or signed integer or boolean";
      assert
        (enum [
          true
          null
          false
        ]).description == "one of true, <null>, false";
      assert
        (submodule { freeformType = attrsOf str; }).description
        == "open submodule of attribute set of string";
      # Comprehensive type constructor description tests
      assert (attrsOf int).description == "attribute set of signed integer";
      assert (attrsOf bool).description == "attribute set of boolean";
      assert (attrsOf (either int str)).description == "attribute set of (signed integer or string)";
      assert (attrsOf (nullOr str)).description == "attribute set of (null or string)";
      assert (attrsOf (listOf str)).description == "attribute set of list of string";
      assert (attrsOf (attrsOf int)).description == "attribute set of attribute set of signed integer";
      assert (attrsOf ints.positive).description == "attribute set of (positive integer, meaning >0)";

      # Test type constructors as attrsOf item types
      assert
        (attrsOf (enum [
          "a"
          "b"
        ])).description == "attribute set of (one of \"a\", \"b\")";
      assert
        (attrsOf (strMatching "[0-9]+")).description
        == "attribute set of string matching the pattern [0-9]+";
      assert (attrsOf (nonEmptyListOf str)).description == "attribute set of non-empty (list of string)"; # TODO: reduce parentheses?
      assert
        (attrsOf (oneOf [
          str
          int
        ])).description == "attribute set of (string or signed integer)";
      assert
        (attrsOf (coercedTo str abort int)).description
        == "attribute set of (signed integer or string convertible to it)";
      assert
        (attrsOf (functionTo str)).description == "attribute set of function that evaluates to a(n) string";
      assert
        (attrsOf (passwdEntry str)).description
        == "attribute set of (string, not containing newlines or colons)";
      assert (attrsOf (uniq str)).description == "attribute set of string";
      assert (attrsOf (unique { message = "test"; } str)).description == "attribute set of string";
      assert
        (attrsOf (pathWith {
          absolute = true;
        })).description == "attribute set of absolute path";
      assert
        (attrsOf (separatedString ",")).description == "attribute set of strings concatenated with \",\"";
      assert (attrsOf (loaOf str)).description == "attribute set of attribute set of string";
      assert (attrsOf (lazyAttrsOf str)).description == "attribute set of lazy attribute set of string";
      assert (attrsOf (submodule { })).description == "attribute set of (submodule)"; # FIXME: extra parentheses around submodule
      assert
        (attrsOf (submodule {
          freeformType = attrsOf str;
        })).description == "attribute set of (open submodule of attribute set of string)";
      assert (attrsOf (addCheck str (x: true))).description == "attribute set of string";
      assert (attrsOf (enum [ ])).description == "attribute set of impossible (empty enum)";
      assert
        (attrsOf ints.u32).description
        == "attribute set of 32 bit unsigned integer; between 0 and 4294967295 (both inclusive)";
      assert
        (attrsOf numbers.positive).description
        == "attribute set of (positive integer or floating point number, meaning >0)";

      assert (attrsWith { elemType = str; }).description == "attribute set of string";
      assert (attrsWith { elemType = int; }).description == "attribute set of signed integer";
      assert (attrsWith { elemType = bool; }).description == "attribute set of boolean";
      assert
        (attrsWith { elemType = either int str; }).description
        == "attribute set of (signed integer or string)";
      assert (attrsWith { elemType = nullOr str; }).description == "attribute set of (null or string)";
      assert (attrsWith { elemType = listOf str; }).description == "attribute set of list of string";
      assert
        (attrsWith { elemType = attrsOf int; }).description
        == "attribute set of attribute set of signed integer";
      assert
        (attrsWith { elemType = ints.positive; }).description
        == "attribute set of (positive integer, meaning >0)";
      assert
        (attrsWith {
          elemType = str;
          lazy = true;
        }).description == "lazy attribute set of string";
      # Additional attrsWith tests are covered above
      assert
        (attrsWith {
          elemType = str;
          lazy = false;
        }).description == "attribute set of string";
      assert (coercedTo str abort int).description == "signed integer or string convertible to it";
      assert (coercedTo int abort str).description == "string or signed integer convertible to it";
      assert (coercedTo bool abort str).description == "string or boolean convertible to it";
      assert
        (coercedTo (either int str) abort str).description
        == "string or (signed integer or string) convertible to it";
      assert
        (coercedTo (nullOr str) abort str).description == "string or (null or string) convertible to it";
      assert
        (coercedTo (listOf str) abort str).description == "string or (list of string) convertible to it";
      assert
        (coercedTo (attrsOf int) abort str).description
        == "string or (attribute set of signed integer) convertible to it";
      assert
        (coercedTo ints.positive abort str).description
        == "string or (positive integer, meaning >0) convertible to it";
      assert
        (coercedTo (listOf str) abort (attrsOf str)).description
        == "(attribute set of string) or (list of string) convertible to it";
      # Additional coercedTo tests covered above
      assert (either str int).description == "string or signed integer";
      assert (either int str).description == "signed integer or string";
      assert (either bool str).description == "boolean or string";
      assert (either (either int str) bool).description == "signed integer or string or boolean";
      assert (either (nullOr str) int).description == "null or string or signed integer";
      assert (either (listOf str) int).description == "(list of string) or signed integer";
      assert (either (attrsOf int) str).description == "(attribute set of signed integer) or string";
      assert (either ints.positive str).description == "positive integer, meaning >0, or string";
      assert (either (either bool str) int).description == "boolean or string or signed integer";

      # Test type constructors as either bool t
      assert (either bool str).description == "boolean or string";
      assert (either bool int).description == "boolean or signed integer";
      assert
        (either bool (enum [
          "a"
          "b"
        ])).description == "boolean or one of \"a\", \"b\"";
      assert
        (either bool (strMatching "[0-9]+")).description == "boolean or string matching the pattern [0-9]+";
      assert (either bool (nonEmptyListOf str)).description == "boolean or non-empty (list of string)"; # TODO: reduce parentheses?
      assert
        (either bool (oneOf [
          str
          int
        ])).description == "boolean or string or signed integer";
      assert
        (either bool (coercedTo str abort int)).description
        == "boolean or (signed integer or string convertible to it)";
      assert
        (either bool (functionTo str)).description == "boolean or function that evaluates to a(n) string";
      assert
        (either bool (passwdEntry str)).description
        == "boolean or (string, not containing newlines or colons)";
      assert (either bool (uniq str)).description == "boolean or string";
      assert (either bool (unique { message = "test"; } str)).description == "boolean or string";
      assert
        (either bool (pathWith {
          absolute = true;
        })).description == "boolean or absolute path";
      assert
        (either bool (separatedString ",")).description == "boolean or strings concatenated with \",\"";
      assert (either bool (attrsOf str)).description == "boolean or attribute set of string";
      assert (either bool (listOf str)).description == "boolean or list of string";
      assert (either bool (nullOr str)).description == "boolean or null or string";
      assert (either bool (lazyAttrsOf str)).description == "boolean or lazy attribute set of string";
      assert (either bool (submodule { })).description == "boolean or (submodule)"; # FIXME: extra parentheses around submodule
      assert (either bool ints.positive).description == "boolean or (positive integer, meaning >0)";
      assert
        (either bool numbers.positive).description
        == "boolean or (positive integer or floating point number, meaning >0)";

      # Test type constructors as either t bool
      assert (either str bool).description == "string or boolean";
      assert (either int bool).description == "signed integer or boolean";
      assert
        (either (enum [
          "a"
          "b"
        ]) bool).description == "one of \"a\", \"b\" or boolean";
      assert
        (either (strMatching "[0-9]+") bool).description == "string matching the pattern [0-9]+ or boolean";
      assert (either (nonEmptyListOf str) bool).description == "(non-empty (list of string)) or boolean"; # TODO: reduce parentheses?
      assert
        (either (oneOf [
          str
          int
        ]) bool).description == "string or signed integer or boolean";
      assert
        (either (coercedTo str abort int) bool).description
        == "(signed integer or string convertible to it) or boolean";
      assert
        (either (functionTo str) bool).description == "(function that evaluates to a(n) string) or boolean";
      assert
        (either (passwdEntry str) bool).description
        == "string, not containing newlines or colons, or boolean";
      assert (either (uniq str) bool).description == "string or boolean";
      assert (either (unique { message = "test"; } str) bool).description == "string or boolean";
      assert (either (pathWith { absolute = true; }) bool).description == "absolute path or boolean";
      assert
        (either (separatedString ",") bool).description == "strings concatenated with \",\" or boolean";
      assert (either (attrsOf str) bool).description == "(attribute set of string) or boolean";
      assert (either (listOf str) bool).description == "(list of string) or boolean";
      assert (either (nullOr str) bool).description == "null or string or boolean";
      assert (either (lazyAttrsOf str) bool).description == "(lazy attribute set of string) or boolean";
      assert (either (submodule { }) bool).description == "(submodule) or boolean"; # FIXME: extra parentheses around submodule
      assert (either ints.positive bool).description == "positive integer, meaning >0, or boolean";
      assert
        (either numbers.positive bool).description
        == "positive integer or floating point number, meaning >0, or boolean";

      # Additional either tests covered above";
      assert (enum [ ]).description == "impossible (empty enum)";
      assert (enum [ "single" ]).description == "value \"single\" (singular enum)";
      assert
        (enum [
          "a"
          "b"
        ]).description == "one of \"a\", \"b\"";
      assert
        (enum [
          true
          false
        ]).description == "one of true, false";
      assert
        (enum [
          1
          2
          3
        ]).description == "one of 1, 2, 3";
      assert (enum [ null ]).description == "value <null> (singular enum)";
      assert (functionTo str).description == "function that evaluates to a(n) string";
      assert (functionTo int).description == "function that evaluates to a(n) signed integer";
      assert (functionTo bool).description == "function that evaluates to a(n) boolean";
      assert
        (functionTo (either int str)).description
        == "function that evaluates to a(n) (signed integer or string)";
      assert (functionTo (nullOr str)).description == "function that evaluates to a(n) (null or string)";
      assert (functionTo (listOf str)).description == "function that evaluates to a(n) list of string";
      assert
        (functionTo (attrsOf int)).description
        == "function that evaluates to a(n) attribute set of signed integer";
      assert
        (functionTo ints.positive).description
        == "function that evaluates to a(n) (positive integer, meaning >0)";
      assert (lazyAttrsOf str).description == "lazy attribute set of string";
      assert (lazyAttrsOf int).description == "lazy attribute set of signed integer";
      assert (lazyAttrsOf bool).description == "lazy attribute set of boolean";
      assert
        (lazyAttrsOf (either int str)).description == "lazy attribute set of (signed integer or string)";
      assert (lazyAttrsOf (nullOr str)).description == "lazy attribute set of (null or string)";
      assert (lazyAttrsOf (listOf str)).description == "lazy attribute set of list of string";
      assert
        (lazyAttrsOf (attrsOf int)).description == "lazy attribute set of attribute set of signed integer";
      assert
        (lazyAttrsOf ints.positive).description == "lazy attribute set of (positive integer, meaning >0)";
      assert (listOf str).description == "list of string";
      assert (listOf int).description == "list of signed integer";
      assert (listOf bool).description == "list of boolean";
      assert (listOf (either int str)).description == "list of (signed integer or string)";
      assert (listOf (nullOr str)).description == "list of (null or string)";
      assert (listOf (listOf str)).description == "list of list of string";
      assert (listOf (attrsOf int)).description == "list of attribute set of signed integer";
      assert (listOf ints.positive).description == "list of (positive integer, meaning >0)";
      assert (loaOf str).description == "attribute set of string";
      assert (loaOf int).description == "attribute set of signed integer";
      assert (loaOf bool).description == "attribute set of boolean";
      assert (loaOf (either int str)).description == "attribute set of (signed integer or string)";
      assert (loaOf (nullOr str)).description == "attribute set of (null or string)";
      assert (loaOf (listOf str)).description == "attribute set of list of string";
      assert (loaOf (attrsOf int)).description == "attribute set of attribute set of signed integer";
      assert (loaOf ints.positive).description == "attribute set of (positive integer, meaning >0)";
      assert (nonEmptyListOf str).description == "non-empty (list of string)"; # TODO: reduce parentheses?
      assert (nonEmptyListOf int).description == "non-empty (list of signed integer)"; # TODO: reduce parentheses?
      assert (nonEmptyListOf bool).description == "non-empty (list of boolean)"; # TODO: reduce parentheses?
      assert
        (nonEmptyListOf (either int str)).description == "non-empty (list of (signed integer or string))"; # TODO: reduce parentheses?
      assert (nonEmptyListOf (nullOr str)).description == "non-empty (list of (null or string))"; # TODO: reduce parentheses?
      assert (nonEmptyListOf (listOf str)).description == "non-empty (list of list of string)"; # TODO: reduce parentheses?
      assert
        (nonEmptyListOf (attrsOf int)).description
        == "non-empty (list of attribute set of signed integer)"; # TODO: reduce parentheses?
      assert
        (nonEmptyListOf ints.positive).description == "non-empty (list of (positive integer, meaning >0))"; # TODO: reduce parentheses?
      assert (nullOr str).description == "null or string";
      assert (nullOr int).description == "null or signed integer";
      assert (nullOr bool).description == "null or boolean";
      assert (nullOr (either int str)).description == "null or signed integer or string";
      assert (nullOr (nullOr str)).description == "null or null or string";
      assert (nullOr (listOf str)).description == "null or (list of string)";
      assert (nullOr (attrsOf int)).description == "null or (attribute set of signed integer)";
      assert (nullOr ints.positive).description == "null or (positive integer, meaning >0)";
      assert (oneOf [ str ]).description == "string";
      assert (oneOf [ int ]).description == "signed integer";
      assert (oneOf [ bool ]).description == "boolean";
      assert (oneOf [ (either int str) ]).description == "signed integer or string";
      assert (oneOf [ (nullOr str) ]).description == "null or string";
      assert (oneOf [ (listOf str) ]).description == "list of string";
      assert (oneOf [ (attrsOf int) ]).description == "attribute set of signed integer";
      assert (oneOf [ ints.positive ]).description == "positive integer, meaning >0";
      assert
        (oneOf [
          str
          int
        ]).description == "string or signed integer";
      assert
        (oneOf [
          str
          int
          bool
        ]).description == "string or signed integer or boolean";
      assert
        (oneOf [
          (listOf str)
          int
          bool
        ]).description == "(list of string) or signed integer or boolean";
      assert
        (oneOf [
          ints.positive
          str
        ]).description == "positive integer, meaning >0, or string";
      assert (passwdEntry str).description == "string, not containing newlines or colons";
      assert (passwdEntry int).description == "signed integer, not containing newlines or colons";
      assert (passwdEntry bool).description == "boolean, not containing newlines or colons";
      assert
        (passwdEntry (either int str)).description
        == "(signed integer or string), not containing newlines or colons";
      assert
        (passwdEntry (nullOr str)).description == "(null or string), not containing newlines or colons";
      assert
        (passwdEntry (listOf str)).description == "(list of string), not containing newlines or colons";
      assert
        (passwdEntry (attrsOf int)).description
        == "(attribute set of signed integer), not containing newlines or colons";
      assert
        (passwdEntry ints.positive).description
        == "(positive integer, meaning >0), not containing newlines or colons";
      assert (pathWith { }).description == "path";
      assert (pathWith { absolute = true; }).description == "absolute path";
      assert (pathWith { inStore = true; }).description == "path in the Nix store";
      assert
        (pathWith {
          absolute = true;
          inStore = true;
        }).description == "absolute path in the Nix store";
      assert (pathWith { absolute = false; }).description == "relative path";
      assert (pathWith { absolute = null; }).description == "path";
      assert (pathWith { inStore = false; }).description == "path not in the Nix store";
      assert (pathWith { inStore = null; }).description == "path";
      assert (separatedString "").description == "Concatenated string";
      assert (separatedString ",").description == "strings concatenated with \",\"";
      assert (separatedString "\n").description == ''strings concatenated with "\n"'';
      assert (separatedString ":").description == "strings concatenated with \":\"";
      assert (strMatching "[a-z]+").description == "string matching the pattern [a-z]+";
      assert
        (strMatching "[0-9]{3}-[0-9]{2}-[0-9]{4}").description
        == "string matching the pattern [0-9]{3}-[0-9]{2}-[0-9]{4}";
      assert (strMatching ".*\\.txt").description == "string matching the pattern .*\\.txt";
      assert
        (submodule { freeformType = attrsOf int; }).description
        == "open submodule of attribute set of signed integer";
      assert
        (submodule { freeformType = attrsOf bool; }).description
        == "open submodule of attribute set of boolean";
      assert
        (submodule { freeformType = attrsOf (either int str); }).description
        == "open submodule of attribute set of (signed integer or string)";
      assert
        (submodule { freeformType = attrsOf (nullOr str); }).description
        == "open submodule of attribute set of (null or string)";
      assert (submodule { freeformType = listOf str; }).description == "open submodule of list of string";
      assert
        (submodule { freeformType = attrsOf ints.positive; }).description
        == "open submodule of attribute set of (positive integer, meaning >0)";
      assert
        (submodule { freeformType = lazyAttrsOf str; }).description
        == "open submodule of lazy attribute set of string";
      assert
        (submodule { freeformType = lazyAttrsOf int; }).description
        == "open submodule of lazy attribute set of signed integer";
      assert
        (submodule { freeformType = lazyAttrsOf (listOf str); }).description
        == "open submodule of lazy attribute set of list of string";
      assert (submodule { }).description == "submodule";
      assert (submodule [ { options.foo = mkOption { type = str; }; } ]).description == "submodule";
      assert (submodule [ ]).description == "submodule";
      assert
        (submodule [ { freeformType = attrsOf str; } ]).description
        == "open submodule of attribute set of string";
      assert
        (submodule [ { freeformType = lazyAttrsOf str; } ]).description
        == "open submodule of lazy attribute set of string";
      assert
        (submodule [ { freeformType = lazyAttrsOf int; } ]).description
        == "open submodule of lazy attribute set of signed integer";
      assert
        (submodule [ { freeformType = lazyAttrsOf (either int str); } ]).description
        == "open submodule of lazy attribute set of (signed integer or string)";
      assert
        (submoduleWith { modules = [ { freeformType = attrsOf str; } ]; }).description
        == "open submodule of attribute set of string";
      assert
        (submoduleWith { modules = [ { freeformType = attrsOf int; } ]; }).description
        == "open submodule of attribute set of signed integer";
      assert
        (submoduleWith { modules = [ { freeformType = attrsOf bool; } ]; }).description
        == "open submodule of attribute set of boolean";
      assert
        (submoduleWith { modules = [ { freeformType = attrsOf (either int str); } ]; }).description
        == "open submodule of attribute set of (signed integer or string)";
      assert
        (submoduleWith { modules = [ { freeformType = attrsOf (nullOr str); } ]; }).description
        == "open submodule of attribute set of (null or string)";
      assert
        (submoduleWith { modules = [ { freeformType = listOf str; } ]; }).description
        == "open submodule of list of string";
      assert
        (submoduleWith { modules = [ { freeformType = lazyAttrsOf str; } ]; }).description
        == "open submodule of lazy attribute set of string";
      assert
        (submoduleWith { modules = [ { freeformType = lazyAttrsOf int; } ]; }).description
        == "open submodule of lazy attribute set of signed integer";
      assert
        (submoduleWith { modules = [ { freeformType = lazyAttrsOf (either int str); } ]; }).description
        == "open submodule of lazy attribute set of (signed integer or string)";
      assert
        (submoduleWith { modules = [ { freeformType = attrsOf ints.positive; } ]; }).description
        == "open submodule of attribute set of (positive integer, meaning >0)";
      assert (submoduleWith { modules = [ ]; }).description == "submodule";
      assert
        (submoduleWith {
          modules = [ ];
          description = "custom";
        }).description == "custom";
      assert
        (submoduleWith {
          modules = [ ];
          description = "custom module";
        }).description == "custom module";
      assert (uniq str).description == "string";
      assert (uniq (either int str)).description == "signed integer or string";
      assert (uniq (listOf str)).description == "list of string";
      assert (unique { message = "test"; } str).description == "string";
      assert (unique { message = ""; } (either int str)).description == "signed integer or string";
      assert (unique { message = "custom"; } (listOf str)).description == "list of string";
      assert (unique { message = "test"; } (either int str)).description == "signed integer or string";
      assert (unique { message = "test"; } (listOf str)).description == "list of string";
      # done
      "ok";
  };
}
