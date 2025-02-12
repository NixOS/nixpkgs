{
  lib ? import ../..,
}:
let
  evalTest = import ./default.nix;

  checkConfigOutput =
    {
      expected,
      modules,
      attrPath ? [
        "config"
        "result"
      ],
    }:
    let
      t = evalTest {
        inherit lib modules;
      };
    in
    {
      expr = lib.getAttrFromPath attrPath t;
      inherit expected;
    };

  checkConfigError =
    {
      expectedError,
      modules,
      attrPath,
    }:
    let
      t = evalTest {
        inherit lib modules;
      };
    in
    {
      expr = lib.getAttrFromPath attrPath t;
      inherit expectedError;
    };

in
{

  testShorthandMeta = checkConfigOutput {
    expected = "one two";
    modules = [
      ./shorthand-meta.nix
    ];
  };

  testMergeAttrDefinitionsWithPrio = checkConfigError {
    expectedError.msg = "It seems as if you.re trying to declare an option by placing it into .config. rather than .options.";
    attrPath = [
      "config"
      "wrong1"
    ];
    modules = [
      ./error-mkOption-in-config.nix
    ];
  };

}
