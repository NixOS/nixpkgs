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
    ];
  };

  test =
    assert
      example.config.meta.maintainers == {
        ${toString ../meta-maintainers.nix} = [
          lib.maintainers.pierron
          lib.maintainers.roberth
        ];
        "ghost.nix" = [ ghost ];
      };
    { };

}
.test
