# Run:
#   $ nix-instantiate --eval 'modules/generic/meta-maintainers/test.nix'
#
# Expected output:
#   { }
#
# Debugging:
#   drop .test from the end of this file, then use nix repl on it
let
  ghost = {
    github = "ghost";
    githubId = 0;
    name = "ghost";
  };
in
rec {
  # Inject ghost into lib.maintainers so it passes the addCheck validation
  lib = (import ../../../lib).extend (
    final: prev: {
      maintainers = prev.maintainers // {
        inherit ghost;
      };
    }
  );

  example = lib.evalModules {
    specialArgs.lib = lib;
    modules = [
      ../meta-maintainers.nix
      {
        _file = "ghost.nix";
        meta.maintainers = [ ghost ];
      }
      {
        _file = "poltergeist.nix";
        meta.maintainers = [ lib.maintainers.roberth ];
      }
    ];
  };

  # Each defining file gets its own entry, and `../meta-maintainers.nix` gets
  # none, because declaring the option does not make its author a maintainer of
  # every module that imports it.
  test =
    assert
      example.config.meta.maintainers == {
        "ghost.nix" = [ ghost ];
        "poltergeist.nix" = [ lib.maintainers.roberth ];
      };
    { };

}
.test
