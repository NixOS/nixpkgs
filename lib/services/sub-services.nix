{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;

  layer1PathModule = {
    key = "_layer-1-path";
    imports = [
      ({ name, ... }: {
        absoluteServicePath = lib.mkDefault [ name ];
      })
    ];
  };
in
{
  options = {
    services = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = [
            ./sub-services.nix
            ({ name, ... }: {
              disabledModules = [ layer1PathModule ];
              config.absoluteServicePath = config.absoluteServicePath ++ [ name ];
            })
            # services.nix import is declared in services.nix
          ];
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

    absoluteServicePath = mkOption {
      type = types.listOf types.str;
      internal = true;
      readOnly = true;
      description = ''
        The absolute service path of this service, from the top-level service.

        Each list item is an attribute name under
        - item 0: right under the modular service integration's root attribute set of services.
        - item n > 0: under the `services` option.

        See ${options.services # if rendered, this is the current location where you're rendering from
        }
      '';
    };
  };
  imports = [
    layer1PathModule
  ];
}
