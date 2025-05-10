# NOTE: Tests related to mapIsSubmap go here.
{
  lib,
  mapIsSubmap,
  runCommand,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt testBuildFailure';

  check =
    {
      name,
      submap,
      supermap,
    }:
    runCommand name
      {
        __structuredAttrs = true;
        strictDeps = true;
        preferLocalBuild = true;
        nativeBuildInputs = [ mapIsSubmap ];
        inherit submap supermap;
      }
      ''
        set -eu
        nixLog "running mapIsSubmap"
        if mapIsSubmap submap supermap; then
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
    name = "mapIsSubmap";
    src = ./mapIsSubmap.bash;
  };

  shfmt = shfmt {
    name = "mapIsSubmap";
    src = ./mapIsSubmap.bash;
  };

  empty = check {
    name = "empty";
    submap = { };
    supermap = { };
  };

  emptyIsSubmap = check {
    name = "emptyIsSubmap";
    submap = { };
    supermap = {
      apple = "fruit";
    };
  };

  singleton = check {
    name = "singleton";
    submap = {
      apple = "fruit";
    };
    supermap = {
      apple = "fruit";
    };
  };

  singletonDifferentValue = testBuildFailure' {
    name = "singletonDifferentValue";
    drv = check {
      name = "singletonDifferentValue";
      submap = {
        apple = "fruit";
      };
      supermap = {
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
      submap = {
        apple = "fruit";
      };
      supermap = {
        banana = "fruit";
      };
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  multiple = check {
    name = "multiple";
    submap = {
      apple = "fruit";
      banana = "fruit";
    };
    supermap = {
      apple = "fruit";
      banana = "fruit";
    };
  };

  missingOneEntry = check {
    name = "missingOneEntry";
    submap = {
      banana = "fruit";
    };
    supermap = {
      apple = "fruit";
      banana = "fruit";
    };
  };

  missingOneEntryDifferentValue = testBuildFailure' {
    name = "missingOneEntryDifferentValue";
    drv = check {
      name = "missingOneEntryDifferentValue";
      submap = {
        banana = "fruit";
      };
      supermap = {
        apple = "fruit";
        banana = "vegetable";
      };
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  submapHasExtraEntry = testBuildFailure' {
    name = "submapHasExtraEntry";
    drv = check {
      name = "submapHasExtraEntry";
      submap = {
        apple = "fruit";
        banana = "fruit";
      };
      supermap = {
        apple = "fruit";
      };
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };
}
