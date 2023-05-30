# Test Cases

# options.TYPe.type = {_type }

# options.ATTrsOf.attrsOf =   { type } | { listOf } | { attrsOf } | { options }
# options.LiSTOf.listOf   =   { type } | { listOf } | { attrsOf } | { options }
# options.OPTions.options = { OPTions =
#                             { type } | { listOf } | { attrsOf } | { options } }

# options.ATTrsOf -> ATTrsOf -> TYPe
# options.ATTrsOf -> LIStOf  -> TYPe
# options.ATTrsOf -> OPTions -> TYPe

# options.LIStOf  -> ATTrsOf -> TYPe
# options.LIStOf  -> LIStOf  -> TYPe
# options.LIStOf  -> OPTions -> TYPe

# options.OPTions -> ATTrsOf -> TYPe
# options.OPTions -> LIStOf  -> TYPe
# options.OPTions -> OPTions -> TYPe

# nix eval --show-trace --impure --expr '(import ./simple-options.nix { lib = (import <nixpkgs> {}).lib; })'|sed 's/.repeated./<repeated>/g'|nix run nixpkgs#alejandra
# alejandra isn't required but provide some nice output


{ lib, ... }:
lib.simpleOptions {
  # Basic cases

  options.ATT.attrsOf     = lib.types.str;
  options.ATT.default     = {};
  options.ATT.description = "attrset of strings";
  options.ATT.example     = {};

  options.LST.default     = [];
  options.LST.description = "list of string";
  options.LST.example     = [];
  options.LST.listOf      = lib.types.str;

  options.TYP.default     = "";
  options.TYP.description = "string option example";
  options.TYP.example     = "some string";
  options.TYP.type        = lib.types.str;

  # Nested attrs

  options.ATT-ATT.default      = {};
  options.ATT-ATT.description  = "attrset of attrset";
  options.ATT-ATT.example      = {};

  options.ATT-LST.default      = {};
  options.ATT-LST.description  = "attrset of lists";
  options.ATT-LST.example      = {};

  options.ATT-ATT.attrsOf.default      = {};
  options.ATT-ATT.attrsOf.description  = "attrset of strings";
  options.ATT-ATT.attrsOf.example      = {};
  options.ATT-ATT.attrsOf.attrsOf      = lib.types.str;

  options.ATT-LST.attrsOf.default      = {};
  options.ATT-LST.attrsOf.description  = "list of strings";
  options.ATT-LST.attrsOf.example      = {};
  options.ATT-LST.attrsOf.listOf       = lib.types.str;

  options.ATT-OPT.attrsOf.default      = {};
  options.ATT-OPT.attrsOf.description  = "options with one attr";
  options.ATT-OPT.attrsOf.example      = {};

  options.ATT-OPT.attrsOf.options.ATT-OPT-TYP.default     = "";
  options.ATT-OPT.attrsOf.options.ATT-OPT-TYP.description = "option of options of attrset";
  options.ATT-OPT.attrsOf.options.ATT-OPT-TYP.type        = lib.types.str;
  options.ATT-OPT.attrsOf.options.ATT-OPT-TYP.example     = "";

  # Nested lists

  options.LST-ATT.default       = [];
  options.LST-ATT.description   = "list of attrset";
  options.LST-ATT.example       = [];

  options.LST-ATT.listOf.default      = [];
  options.LST-ATT.listOf.description  = "attrset of strings";
  options.LST-ATT.listOf.example      = [];
  options.LST-ATT.listOf.attrsOf      = lib.types.str;

  options.LST-LST.default       = {};
  options.LST-LST.description   = "list of lists";
  options.LST-LST.example       = {};

  options.LST-LST.listOf.default      = {};
  options.LST-LST.listOf.description  = "list of strings";
  options.LST-LST.listOf.example      = {};
  options.LST-LST.listOf.listOf       = lib.types.str;

  options.LST-OPT.default       = {};
  options.LST-OPT.description   = "list of options";
  options.LST-OPT.example       = {};

  options.LST-OPT.listOf.default      = {};
  options.LST-OPT.listOf.description  = "options with one attr";
  options.LST-OPT.listOf.example      = {};

  options.LST-OPT.listOf.options.LST-OPT-TYP.default     = "";
  options.LST-OPT.listOf.options.LST-OPT-TYP.description = "option of options of lists";
  options.LST-OPT.listOf.options.LST-OPT-TYP.type        = lib.types.str;
  options.LST-OPT.listOf.options.LST-OPT-TYP.example     = "";

  # Nested options

  options.OPT.default     = {};
  options.OPT.example     = {};
  options.OPT.description = "options holder";

  options.OPT.options.OPT-TYP.default     = "";
  options.OPT.options.OPT-TYP.description = "second level str";
  options.OPT.options.OPT-TYP.type        = lib.types.str;
  options.OPT.options.OPT-TYP.example     = "some string";

  options.OPT.options.OPT-ATT.default     = {};
  options.OPT.options.OPT-ATT.description = "second level attrset of strings";
  options.OPT.options.OPT-ATT.attrsOf     = lib.types.str;
  options.OPT.options.OPT-ATT.example     = {};

  options.OPT.options.OPT-LST.default     = [];
  options.OPT.options.OPT-LST.description = "second level list of strings";
  options.OPT.options.OPT-LST.listOf      = lib.types.str;
  options.OPT.options.OPT-LST.example     = [];

  options.OPT.options.OPT-OPT.default     = {};
  options.OPT.options.OPT-OPT.example     = {};
  options.OPT.options.OPT-OPT.description = "second level options holder";

  options.OPT.options.OPT-OPT.options.OPT-OPT-TYP.default     = "";
  options.OPT.options.OPT-OPT.options.OPT-OPT-TYP.description = "third level str";
  options.OPT.options.OPT-OPT.options.OPT-OPT-TYP.type        = lib.types.str;
  options.OPT.options.OPT-OPT.options.OPT-OPT-TYP.example     = "some string";

  options.OPT.options.OPT-OPT.options.OPT-OPT-ATT.default     = {};
  options.OPT.options.OPT-OPT.options.OPT-OPT-ATT.description = "Third level hasmap of strings str";
  options.OPT.options.OPT-OPT.options.OPT-OPT-ATT.attrsOf     = lib.types.str;
  options.OPT.options.OPT-OPT.options.OPT-OPT-ATT.example     = {};

  options.OPT.options.OPT-OPT.options.OPT-OPT-LST.default     = [];
  options.OPT.options.OPT-OPT.options.OPT-OPT-LST.description = "Third level list of strings str";
  options.OPT.options.OPT-OPT.options.OPT-OPT-LST.listOf      = lib.types.str;
  options.OPT.options.OPT-OPT.options.OPT-OPT-LST.example     = [];
}
