{ lib, ... }:
let
  inherit (lib) types;
in
{
  options = {
    name = lib.mkOption {
      type = types.str;
    };
    github = lib.mkOption {
      type = types.str;
    };
    githubId = lib.mkOption {
      type = types.ints.unsigned;
    };
    email = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    matrix = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    keys = lib.mkOption {
      type = types.listOf (
        types.submodule {
          options.fingerprint = lib.mkOption { type = types.str; };
        }
      );
      default = [ ];
    };
  };
}
