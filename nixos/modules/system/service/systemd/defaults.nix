{
  lib,
  ...
}:
let
  inherit (lib) types;
in
{
  _class = "nixos";

  options.modularServices = lib.mkOption {
    type = types.attrsOf (types.attrsOf types.deferredModule);
    description = ''
      Environment-specific variant of the [modular
      services](https://nixos.org/manual/nixos/unstable/#modular-services),
      keyed by `<pkg>.<service>`.

      Import the variant matching the target environment, e.g.:

      ```nix
      imports = [ config.modularServices.ghostunnel.default ];
      ```
    '';
    default = (import ../modular).system;
    # The default is an attribute set of paths into the module tree. Rendering
    # it would make the option documentation refer to the sandboxed copy of
    # that tree, which `lazy-options.json` disallows.
    defaultText = lib.literalExpression "(import ../modular).system";
  };
}
