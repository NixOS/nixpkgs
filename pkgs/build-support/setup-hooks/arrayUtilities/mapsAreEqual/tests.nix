# NOTE: Tests related to mapsAreEqual go here.
{
  lib,
  mapsAreEqual,
  runCommand,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt testBuildFailure';

  check =
    {
      name,
      map1,
      map2,
    }:
    runCommand name
      {
        __structuredAttrs = true;
        strictDeps = true;
        preferLocalBuild = true;
        nativeBuildInputs = [ mapsAreEqual ];
        inherit map1 map2;
      }
      ''
        set -eu
        nixLog "running mapsAreEqual"
        if mapsAreEqual map1 map2; then
          nixLog "test passed"
          touch "$out"
        else
          nixErrorLog "test failed"
          exit 1
        fi
      '';
in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "mapsAreEqual";
    src = ./mapsAreEqual.bash;
  };

  shfmt = shfmt {
    name = "mapsAreEqual";
    src = ./mapsAreEqual.bash;
  };

  empty = check {
    name = "empty";
    map1 = { };
    map2 = { };
  };

  singleton = check {
    name = "singleton";
    map1 = {
      apple = "fruit";
    };
    map2 = {
      apple = "fruit";
    };
  };

  singletonDifferentValue = testBuildFailure' {
    name = "singletonDifferentValue";
    drv = check {
      name = "singletonDifferentValue";
      map1 = {
        apple = "fruit";
      };
      map2 = {
        apple = "vegetable";
      };
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  singletonDifferentKey = testBuildFailure' {
    name = "singletonDifferentKey";
    drv = check {
      name = "singletonDifferentKey";
      map1 = {
        apple = "fruit";
      };
      map2 = {
        banana = "fruit";
      };
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  multiple = check {
    name = "multiple";
    map1 = {
      apple = "fruit";
      banana = "fruit";
    };
    map2 = {
      apple = "fruit";
      banana = "fruit";
    };
  };

  multipleDifferentValue = testBuildFailure' {
    name = "multipleDifferentValue";
    drv = check {
      name = "multipleDifferentValue";
      map1 = {
        apple = "fruit";
        banana = "fruit";
      };
      map2 = {
        apple = "fruit";
        banana = "vegetable";
      };
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  multipleDifferentKey = testBuildFailure' {
    name = "multipleDifferentKey";
    drv = check {
      name = "multipleDifferentKey";
      map1 = {
        apple = "fruit";
        banana = "fruit";
      };
      map2 = {
        apple = "fruit";
        carrot = "vegetable";
      };
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };
}
