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
    mkOption
    types
    ;

  cfg = config.nix;

in
{
  options = {
    nix = {
      registry = mkOption {
        type = types.attrsOf (
          types.submodule (
            let
              referenceAttrs =
                with types;
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
                from = mkOption {
                  type = referenceAttrs;
                  example = {
                    type = "indirect";
                    id = "nixpkgs";
                  };
                  description = "The flake reference to be rewritten.";
                };
                to = mkOption {
                  type = referenceAttrs;
                  example = {
                    type = "github";
                    owner = "my-org";
                    repo = "my-nixpkgs";
                  };
                  description = "The flake reference {option}`from` is rewritten to.";
                };
                flake = mkOption {
                  type = types.nullOr types.attrs;
                  default = null;
                  example = literalExpression "nixpkgs";
                  description = ''
                    The flake input {option}`from` is rewritten to.
                  '';
                };
                exact = mkOption {
                  type = types.bool;
                  default = true;
                  description = ''
                    Whether the {option}`from` reference needs to match exactly. If set,
                    a {option}`from` reference like `nixpkgs` does not
                    match with a reference like `nixpkgs/nixos-20.03`.
                  '';
                };
              };
              config = {
                from = mkDefault {
                  type = "indirect";
                  id = name;
                };
                to = mkIf (config.flake != null) (
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

  config = mkIf cfg.enable {
    environment.etc."nix/registry.json".text = builtins.toJSON {
      version = 2;
      flakes = mapAttrsToList (n: v: { inherit (v) from to exact; }) cfg.registry;
    };
  };
}
