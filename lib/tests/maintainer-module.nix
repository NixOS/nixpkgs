{ lib, ... }:
let
  inherit (lib) types;
  baseDataOptions = {
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
  affiliationOptions = baseDataOptions // {
    fallbackMaintainers = lib.mkOption {
      type = types.listOf (types.submodule { options = baseDataOptions; });
      default = [ ];
    };
    contactUnresponsive = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };
in
{
  options = baseDataOptions // {
    affiliation = lib.mkOption {
      type = types.attrsOf (types.submodule { options = affiliationOptions; });
      default = { };
    };
  };
}
