{ lib, ... }:
let
  inherit (lib) types mkOption setDefaultModuleLocation;
  inherit (types)
    deferredModule
    lazyAttrsOf
    submodule
    str
    raw
    enum
    ;
in
{
  imports = [
    # generic module, declaring submodules:
    #   - nodes.<name>
    #   - default
    # where all nodes include the default
    (
      { config, ... }:
      {
        _file = "generic.nix";
        options.nodes = mkOption {
          type = lazyAttrsOf (submodule {
            imports = [ config.default ];
          });
          default = { };
        };
        options.default = mkOption {
          type = deferredModule;
          default = { };
          description = ''
            Module that is included in all nodes.
          '';
        };
      }
    )

    {
      _file = "default-1.nix";
      default =
        { config, ... }:
        {
          options.settingsDict = lib.mkOption {
            type = lazyAttrsOf str;
            default = { };
          };
          options.bottom = lib.mkOption { type = enum [ ]; };
        };
    }

    {
      _file = "default-a-is-b.nix";
      default = ./define-settingsDict-a-is-b.nix;
    }

    {
      _file = "nodes-foo.nix";
      nodes.foo.settingsDict.b = "beta";
    }

    {
      _file = "the-file-that-contains-the-bad-config.nix";
      default.bottom = "bogus";
    }

    {
      _file = "nodes-foo-c-is-a.nix";
      nodes.foo =
        { config, ... }:
        {
          settingsDict.c = config.settingsDict.a;
        };
    }

  ];
}
