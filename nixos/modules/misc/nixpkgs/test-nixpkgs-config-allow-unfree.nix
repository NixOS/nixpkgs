# Test for allowUnfreePackages merging across multiple modules
# Run with: nix-build -A nixosTests.nixpkgs-config-allow-unfree --show-trace

{
  evalMinimalConfig,
  lib,
}:
let
  eval =
    modules:
    evalMinimalConfig {
      imports = [
        ../nixpkgs.nix
      ]
      ++ modules;
    };

  getConfig = evalResult: evalResult.config.nixpkgs.config;

  sortList = list: builtins.sort builtins.lessThan list;

  assertEquals =
    expected: actual:
    let
      prettyExpected = lib.generators.toPretty { } expected;
      prettyActual = lib.generators.toPretty { } actual;
    in
    lib.assertMsg (expected == actual) "Expected ${prettyExpected} but got ${prettyActual}";

  assertUnfreePackages =
    listOfModules: expectedPackages:
    let
      config = getConfig (eval listOfModules);
      actualAllowedUnfreePackages = sortList config.allowUnfreePackages;
    in
    assertEquals expectedPackages actualAllowedUnfreePackages;
in
lib.recurseIntoAttrs {

  singleModuleTest =
    assertUnfreePackages
      [
        {
          nixpkgs.config.allowUnfreePackages = [
            "package1"
            "package2"
          ];
        }
      ]
      [
        "package1"
        "package2"
      ];

  multipleModulesMerging =
    assertUnfreePackages
      [
        {
          _file = "module1.nix";
          nixpkgs.config.allowUnfreePackages = [
            "package1"
            "package2"
          ];
        }
        {
          _file = "module2.nix";
          nixpkgs.config.allowUnfreePackages = [
            "package3"
            "package4"
          ];
        }
        {
          _file = "module3.nix";
          nixpkgs.config.allowUnfreePackages = [ "package5" ];
        }
      ]
      [
        "package1"
        "package2"
        "package3"
        "package4"
        "package5"
      ];

  overlappingPackagesMerging =
    assertUnfreePackages
      [
        {
          _file = "moduleA.nix";
          nixpkgs.config.allowUnfreePackages = [
            "shared-package"
            "unique-a"
          ];
        }
        {
          _file = "moduleB.nix";
          nixpkgs.config.allowUnfreePackages = [
            "shared-package"
            "unique-b"
          ];
        }
      ]
      [
        "shared-package"
        "shared-package"
        "unique-a"
        "unique-b"
      ];

  emptyListMerging =
    assertUnfreePackages
      [
        {
          _file = "empty.nix";
          nixpkgs.config.allowUnfreePackages = [ ];
        }
        {
          _file = "non-empty.nix";
          nixpkgs.config.allowUnfreePackages = [ "some-package" ];
        }
      ]
      [ "some-package" ];

}
