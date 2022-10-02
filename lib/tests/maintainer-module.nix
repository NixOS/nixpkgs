{ lib, ... }:
let
  inherit (lib) types;
in {
  options = {
    name = lib.mkOption {
      type = types.str;
    };
    email = lib.mkOption {
      type = types.str;
    };
    matrix = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    github = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    githubId = lib.mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
    };
    keys = lib.mkOption {
      type = types.listOf (types.submodule {
        options.fingerprint = lib.mkOption { type = types.str; };
      });
      default = [];
    };
  };
}
