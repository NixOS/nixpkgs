/*
  Manages the flake registry.

  See also
   - ./nix.nix
   - ./nix-channel.nix
*/
{ config, lib, ... }:
let
  inherit (lib)
    filterAttrs
    literalExpression
    mapAttrsToList
    mkDefault
    mkIf
    lib.mkOption
    types
    ;

  cfg = config.nix;

in
{
  options = {
    nix = {
      registry = lib.mkOption {
        type = lib.types.attrsOf (
          types.submodule (
            let
              referenceAttrs =
                with lib.types;
                attrsOf (oneOf [
                  str
                  int
                  bool
                  path
                  package
                ]);
            in
            { config, name, ... }:
            {
              options = {
                from = lib.mkOption {
                  type = referenceAttrs;
                  example = {
                    type = "indirect";
                    id = "nixpkgs";
                  };
                  description = "The flake reference to be rewritten.";
                };
                to = lib.mkOption {
                  type = referenceAttrs;
                  example = {
                    type = "github";
                    owner = "my-org";
                    repo = "my-nixpkgs";
                  };
                  description = "The flake reference {option}`from` is rewritten to.";
                };
                flake = lib.mkOption {
                  type = lib.types.nullOr lib.types.attrs;
                  default = null;
                  example = lib.literalExpression "nixpkgs";
                  description = ''
                    The flake input {option}`from` is rewritten to.
                  '';
                };
                exact = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = ''
                    Whether the {option}`from` reference needs to match exactly. If set,
                    a {option}`from` reference like `nixpkgs` does not
                    match with a reference like `nixpkgs/nixos-20.03`.
                  '';
                };
              };
              config = {
                from = lib.mkDefault {
                  type = "indirect";
                  id = name;
                };
                to = lib.mkIf (config.flake != null) (
                  mkDefault (
                    {
                      type = "path";
                      path = config.flake.outPath;
                    }
                    // filterAttrs (n: _: n == "lastModified" || n == "rev" || n == "narHash") config.flake
                  )
                );
              };
            }
          )
        );
        default = { };
        description = ''
          A system-wide flake registry.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."nix/registry.json".text = builtins.toJSON {
      version = 2;
      flakes = mapAttrsToList (n: v: { inherit (v) from to exact; }) cfg.registry;
    };
  };
}
