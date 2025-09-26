# Run:
#   $ nix-instantiate --eval 'modules/generic/meta-maintainers/test.nix'
#
# Expected output:
#   { }
#
# Debugging:
#   drop .test from the end of this file, then use nix repl on it
rec {
  lib = import ../../../lib;

  example = lib.evalModules {
    modules = [
      ../meta-maintainers.nix
      {
        _file = "eelco.nix";
        meta.maintainers = [ lib.maintainers.eelco ];
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
        "eelco.nix" = [ lib.maintainers.eelco ];
      };
    { };

}
.test
