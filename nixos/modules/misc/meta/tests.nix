{ lib, evalMinimalConfig, ... }:

rec {
  exampleModule1 = {
    _file = "/tests/example.nix";
    meta.tests =
      { nixosTests }:
      {
        qux = nixosTests.foo;
      };
  };

  exampleA = evalMinimalConfig {
    imports = [
      {
        _module.args.pkgs = {
          nixosTests = nixosTestsA;
        };
      }
      ../meta.nix
      exampleModule1
    ];
  };
  nixosTestsA = {
    foo = lib.recurseIntoAttrs {
      bar = "Dummy nixosTestsA.foo.bar";
    };
  };
  testsA = exampleA.config.meta.tests;

  evalTests =
    ok:
    assert
      exampleA.config.meta.tests.byModulePath."/tests/example.nix" == {
        qux = lib.recurseIntoAttrs {
          bar = "Dummy nixosTestsA.foo.bar";
        };
      };
    ok;

}
