{ lib, options, ... }:
let
  discardPositions = lib.mapAttrs (k: v: v);
in
# unsafeGetAttrPos is unspecified best-effort behavior, so we only want to consider this test on an evaluator that satisfies some basic assumptions about this function.
assert builtins.unsafeGetAttrPos "a" { a = true; } != null;
assert
  builtins.unsafeGetAttrPos "a" (discardPositions {
    a = true;
  }) == null;
{
  imports = [
    {
      options.imported.line14 = lib.mkOption {
        type = lib.types.int;
      };

      # Simulates various patterns of generating modules such as
      # programs.firefox.nativeMessagingHosts.ff2mpv. We don't expect to get
      # line numbers for these, but we can fall back on knowing the file.
      options.generated = discardPositions {
        line22 = lib.mkOption {
          type = lib.types.int;
        };
      };

      options.submoduleLine38.extraOptLine27 = lib.mkOption {
        default = 1;
        type = lib.types.int;
      };
    }
  ];

  options.nested.nestedLine34 = lib.mkOption {
    type = lib.types.int;
  };

  options.submoduleLine38 = lib.mkOption {
    default = { };
    type = lib.types.submoduleWith {
      modules = [
        (
          { options, ... }:
          {
            options.submodDeclLine45 = lib.mkOption { };
          }
        )
        { freeformType = with lib.types; lazyAttrsOf (uniq unspecified); }
      ];
    };
  };

  config = {
    submoduleLine38.submodDeclLine45 =
      (options.submoduleLine38.type.getSubOptions [ ]).submodDeclLine45.declarationPositions;
  };
}
