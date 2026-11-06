{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    services = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          # Declared elsewhere
          modules = [ ];
        }
      );
      description = ''
        A collection of [modular services](https://nixos.org/manual/nixos/unstable/#modular-services) that are configured in one go.

        You could consider the sub-service relationship to be an ownership relation.
        It **does not** automatically create any other relationship between services (e.g. systemd slices), unless perhaps such a behavior is explicitly defined and enabled in another option.
      '';
      default = { };
      visible = "shallow";
    };
  };
}
