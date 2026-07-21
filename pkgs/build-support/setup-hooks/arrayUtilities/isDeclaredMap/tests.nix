# NOTE: Tests related to isDeclaredMap go here.
{
  isDeclaredMap,
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
    preferLocalBuild = true;
    nativeBuildInputs = [ isDeclaredMap ];
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

      if isDeclaredMap check; then
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
    name = "isDeclaredMap";
    src = ./isDeclaredMap.bash;
  };

  shfmt = shfmt {
    name = "isDeclaredMap";
    src = ./isDeclaredMap.bash;
  };

  undeclaredFails = testBuildFailure' {
    name = "undeclaredFails";
    drv = runCommand "undeclared" commonArgs ''
      set -eu
      if isDeclaredMap undeclared; then
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

  arrayFails = testBuildFailure' {
    name = "arrayFails";
    drv = runCommand "array" commonArgs ''
      set -eu
      local -a array
      if isDeclaredMap array; then
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
      if isDeclaredMap ""; then
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

  sameScopeEmptyMapFails = testBuildFailure' {
    name = "sameScopeEmptyMapFails";
    drv = check {
      name = "sameScopeEmptyMap";
      scope = null;
      intro = null;
      values = "()";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  # Fails because maps must be declared with the -A flag.
  sameScopeSingletonMapFails = testBuildFailure' {
    name = "sameScopeSingletonMapFails";
    drv = check {
      name = "sameScopeSingletonMap";
      scope = null;
      intro = null;
      values = ''([greeting]="hello!")'';
    };
    expectedBuilderLogEntries = [
      "greeting: unbound variable"
    ];
  };

  sameScopeLocalUnsetMap = check {
    name = "sameScopeLocalUnsetMap";
    scope = null;
    intro = "local -A";
    values = null;
  };

  sameScopeLocalEmptyMap = check {
    name = "sameScopeLocalEmptyMap";
    scope = null;
    intro = "local -A";
    values = "()";
  };

  sameScopeLocalSingletonMap = check {
    name = "sameScopeLocalSingletonMap";
    scope = null;
    intro = "local -A";
    values = ''([greeting]="hello!")'';
  };

  sameScopeDeclareUnsetMap = check {
    name = "sameScopeDeclareUnsetMap";
    scope = null;
    intro = "declare -A";
    values = null;
  };

  sameScopeDeclareEmptyMap = check {
    name = "sameScopeDeclareEmptyMap";
    scope = null;
    intro = "declare -A";
    values = "()";
  };

  sameScopeDeclareSingletonMap = check {
    name = "sameScopeDeclareSingletonMap";
    scope = null;
    intro = "declare -A";
    values = ''([greeting]="hello!")'';
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

  # Fails because () is ambiguous and defaults to array rather than associative array.
  previousScopeEmptyMapFails = testBuildFailure' {
    name = "previousScopeEmptyMapFails";
    drv = check {
      name = "previousScopeEmptyMap";
      scope = "function";
      intro = null;
      values = "()";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeSingletonMapFails = testBuildFailure' {
    name = "previousScopeSingletonMapFails";
    drv = check {
      name = "previousScopeSingletonMap";
      scope = "function";
      intro = null;
      values = ''([greeting]="hello!")'';
    };
    expectedBuilderLogEntries = [
      "greeting: unbound variable"
    ];
  };

  previousScopeLocalUnsetMapFails = testBuildFailure' {
    name = "previousScopeLocalUnsetMapFails";
    drv = check {
      name = "previousScopeLocalUnsetMap";
      scope = "function";
      intro = "local -A";
      values = null;
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeLocalEmptyMapFails = testBuildFailure' {
    name = "previousScopeLocalEmptyMapFails";
    drv = check {
      name = "previousScopeLocalEmptyMap";
      scope = "function";
      intro = "local -A";
      values = "()";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeLocalSingletonMapFails = testBuildFailure' {
    name = "previousScopeLocalSingletonMapFails";
    drv = check {
      name = "previousScopeLocalSingletonMap";
      scope = "function";
      intro = "local -A";
      values = ''([greeting]="hello!")'';
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeLocalGlobalUnsetMap = check {
    name = "previousScopeLocalGlobalUnsetMap";
    scope = "function";
    intro = "local -Ag";
    values = null;
  };

  previousScopeLocalGlobalEmptyMap = check {
    name = "previousScopeLocalGlobalEmptyMap";
    scope = "function";
    intro = "local -Ag";
    values = "()";
  };

  previousScopeLocalGlobalSingletonMap = check {
    name = "previousScopeLocalGlobalSingletonMap";
    scope = "function";
    intro = "local -Ag";
    values = ''([greeting]="hello!")'';
  };

  previousScopeDeclareUnsetMapFails = testBuildFailure' {
    name = "previousScopeDeclareUnsetMapFails";
    drv = check {
      name = "previousScopeDeclareUnsetMap";
      scope = "function";
      intro = "declare -A";
      values = null;
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeDeclareEmptyMapFails = testBuildFailure' {
    name = "previousScopeDeclareEmptyMapFails";
    drv = check {
      name = "previousScopeDeclareEmptyMap";
      scope = "function";
      intro = "declare -A";
      values = "()";
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeDeclareSingletonMapFails = testBuildFailure' {
    name = "previousScopeDeclareSingletonMapFails";
    drv = check {
      name = "previousScopeDeclareSingletonMap";
      scope = "function";
      intro = "declare -A";
      values = ''([greeting]="hello!")'';
    };
    expectedBuilderLogEntries = [
      "test failed"
    ];
  };

  previousScopeDeclareGlobalUnsetMap = check {
    name = "previousScopeDeclareGlobalUnsetMap";
    scope = "function";
    intro = "declare -Ag";
    values = null;
  };

  previousScopeDeclareGlobalEmptyMap = check {
    name = "previousScopeDeclareGlobalEmptyMap";
    scope = "function";
    intro = "declare -Ag";
    values = "()";
  };

  previousScopeDeclareGlobalSingletonMap = check {
    name = "previousScopeDeclareGlobalSingletonMap";
    scope = "function";
    intro = "declare -Ag";
    values = ''([greeting]="hello!")'';
  };
}
