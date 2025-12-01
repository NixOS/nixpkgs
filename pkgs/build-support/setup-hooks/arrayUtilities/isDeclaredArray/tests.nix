# NOTE: Tests related to isDeclaredArray go here.
{
  isDeclaredArray,
  lib,
  runCommand,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt testBuildFailure';

  commonArgs = {
    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [ isDeclaredArray ];
  };

  check =
    let
      mkLine =
        intro: values:
        "${if intro == null then "" else intro + " "}check${if values == null then "" else "=" + values}";
      mkScope =
        scope: line:
        if scope == null then
          line
        else if scope == "function" then
          ''
            foo() {
              ${line}
            }
            foo
          ''
        else
          throw "Invalid scope: ${scope}";
    in
    {
      name,
      scope,
      intro,
      values,
    }:
    runCommand name commonArgs ''
      set -eu

      ${mkScope scope (mkLine intro values)}

      if isDeclaredArray check; then
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
    name = "isDeclaredArray";
    src = ./isDeclaredArray.bash;
  };

  shfmt = shfmt {
    name = "isDeclaredArray";
    src = ./isDeclaredArray.bash;
  };

  undeclaredFails = testBuildFailure' {
    name = "undeclaredFails";
    drv = runCommand "undeclared" commonArgs ''
      set -eu
      if isDeclaredArray undeclared; then
        nixLog "test passed"
        touch "$out"
      else
        nixErrorLog "test failed"
        exit 1
      fi
    '';
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  mapFails = testBuildFailure' {
    name = "mapFails";
    drv = runCommand "map" commonArgs ''
      set -eu
      local -A map
      if isDeclaredArray map; then
        nixLog "test passed"
        touch "$out"
      else
        nixErrorLog "test failed"
        exit 1
      fi
    '';
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  emptyStringNamerefFails = testBuildFailure' {
    name = "emptyStringNamerefFails";
    drv = runCommand "emptyStringNameref" commonArgs ''
      set -eu
      if isDeclaredArray ""; then
        nixLog "test passed"
        touch "$out"
      else
        nixErrorLog "test failed"
        exit 1
      fi
    '';
    expectedBuilderLogEntries = [
      "local: `': not a valid identifier"
      "test failed"
    ];
  };

  namerefToEmptyStringFails = testBuildFailure' {
    name = "namerefToEmptyStringFails";
    drv = check {
      name = "namerefToEmptyString";
      scope = null;
      intro = "local -n";
      values = "";
    };
    expectedBuilderLogEntries = [
      "local: `': not a valid identifier"
      # The test fails in such a way that it exits immediately, without returning to the else branch.
    ];
  };

  sameScopeEmptyStringFails = testBuildFailure' {
    name = "sameScopeEmptyStringFails";
    drv = check {
      name = "sameScopeEmptyString";
      scope = null;
      intro = null;
      values = "";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  sameScopeEmptyArray = check {
    name = "sameScopeEmptyArray";
    scope = null;
    intro = null;
    values = "()";
  };

  sameScopeSingletonArray = check {
    name = "sameScopeSingletonArray";
    scope = null;
    intro = null;
    values = ''("hello!")'';
  };

  sameScopeLocalUnsetArray = check {
    name = "sameScopeLocalUnsetArray";
    scope = null;
    intro = "local -a";
    values = null;
  };

  sameScopeLocalEmptyArray = check {
    name = "sameScopeLocalEmptyArray";
    scope = null;
    intro = "local -a";
    values = "()";
  };

  sameScopeLocalSingletonArray = check {
    name = "sameScopeLocalSingletonArray";
    scope = null;
    intro = "local -a";
    values = ''("hello!")'';
  };

  sameScopeDeclareUnsetArray = check {
    name = "sameScopeDeclareUnsetArray";
    scope = null;
    intro = "declare -a";
    values = null;
  };

  sameScopeDeclareEmptyArray = check {
    name = "sameScopeDeclareEmptyArray";
    scope = null;
    intro = "declare -a";
    values = "()";
  };

  sameScopeDeclareSingletonArray = check {
    name = "sameScopeDeclareSingletonArray";
    scope = null;
    intro = "declare -a";
    values = ''("hello!")'';
  };

  previousScopeEmptyStringFails = testBuildFailure' {
    name = "previousScopeEmptyStringFails";
    drv = check {
      name = "previousScopeEmptyString";
      scope = "function";
      intro = null;
      values = "";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  # Works because the variable isn't lexically scoped.
  previousScopeEmptyArray = check {
    name = "previousScopeEmptyArray";
    scope = "function";
    intro = null;
    values = "()";
  };

  # Works because the variable isn't lexically scoped.
  previousScopeSingletonArray = check {
    name = "previousScopeSingletonArray";
    scope = "function";
    intro = null;
    values = ''("hello!")'';
  };

  previousScopeLocalUnsetArrayFails = testBuildFailure' {
    name = "previousScopeLocalUnsetArrayFails";
    drv = check {
      name = "previousScopeLocalUnsetArray";
      scope = "function";
      intro = "local -a";
      values = null;
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeLocalEmptyArrayFails = testBuildFailure' {
    name = "previousScopeLocalEmptyArrayFails";
    drv = check {
      name = "previousScopeLocalEmptyArray";
      scope = "function";
      intro = "local -a";
      values = "()";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeLocalSingletonArrayFails = testBuildFailure' {
    name = "previousScopeLocalSingletonArrayFails";
    drv = check {
      name = "previousScopeLocalSingletonArray";
      scope = "function";
      intro = "local -a";
      values = ''("hello!")'';
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeLocalGlobalUnsetArray = check {
    name = "previousScopeLocalGlobalUnsetArray";
    scope = "function";
    intro = "local -ag";
    values = null;
  };

  previousScopeLocalGlobalEmptyArray = check {
    name = "previousScopeLocalGlobalEmptyArray";
    scope = "function";
    intro = "local -ag";
    values = "()";
  };

  previousScopeLocalGlobalSingletonArray = check {
    name = "previousScopeLocalGlobalSingletonArray";
    scope = "function";
    intro = "local -ag";
    values = ''("hello!")'';
  };

  previousScopeDeclareUnsetArrayFails = testBuildFailure' {
    name = "previousScopeDeclareUnsetArrayFails";
    drv = check {
      name = "previousScopeDeclareUnsetArray";
      scope = "function";
      intro = "declare -a";
      values = null;
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeDeclareEmptyArrayFails = testBuildFailure' {
    name = "previousScopeDeclareEmptyArrayFails";
    drv = check {
      name = "previousScopeDeclareEmptyArray";
      scope = "function";
      intro = "declare -a";
      values = "()";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeDeclareSingletonArrayFails = testBuildFailure' {
    name = "previousScopeDeclareSingletonArrayFails";
    drv = check {
      name = "previousScopeDeclareSingletonArray";
      scope = "function";
      intro = "declare -a";
      values = ''("hello!")'';
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeDeclareGlobalUnsetArray = check {
    name = "previousScopeDeclareGlobalUnsetArray";
    scope = "function";
    intro = "declare -ag";
    values = null;
  };

  previousScopeDeclareGlobalEmptyArray = check {
    name = "previousScopeDeclareGlobalEmptyArray";
    scope = "function";
    intro = "declare -ag";
    values = "()";
  };

  previousScopeDeclareGlobalSingletonArray = check {
    name = "previousScopeDeclareGlobalSingletonArray";
    scope = "function";
    intro = "declare -ag";
    values = ''("hello!")'';
  };
}
