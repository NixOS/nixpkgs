# pkgs.makeSetupHook {#sec-pkgs.makeSetupHook}

`pkgs.makeSetupHook` is a build helper that produces hooks that go into `nativeBuildInputs`

## Usage {#sec-pkgs.makeSetupHook-usage}

```nix
pkgs.makeSetupHook {
  name = "something-hook";
  propagatedBuildInputs = [ pkgs.commandsomething ];
  depsTargetTargetPropagated = [ pkgs.libsomething ];
} ./script.sh
```

### setup hook that depends on the hello package and runs hello and @shell@ is substituted with path to bash {#sec-pkgs.makeSetupHook-usage-example}

```nix
pkgs.makeSetupHook
  {
    name = "run-hello-hook";
    # Put dependencies here if they have hooks or necessary dependencies propagated
    # otherwise prefer direct paths to executables.
    propagatedBuildInputs = [
      pkgs.hello
      pkgs.cowsay
    ];
    substitutions = {
      shell = "${pkgs.bash}/bin/bash";
      cowsay = "${pkgs.cowsay}/bin/cowsay";
    };
  }
  (
    writeScript "run-hello-hook.sh" ''
      #!@shell@
      # the direct path to the executable has to be here because
      # this will be run when the file is sourced
      # at which point '$PATH' has not yet been populated with inputs
      @cowsay@ cow

      _printHelloHook() {
        hello
      }
      preConfigureHooks+=(_printHelloHook)
    ''
  )
```

## Default substitutions {#sec-pkgs.makeSetupHook-default-substitutions}

`@name@`, `@pname@`, `@version@` and `@system@` are always substituted, without being listed in `substitutions`. Everything else must be declared explicitly.

## Attributes {#sec-pkgs.makeSetupHook-attributes}

* `name` Set the name of the hook.
* `propagatedBuildInputs` Runtime dependencies (such as binaries) of the hook.
* `depsTargetTargetPropagated` Non-binary dependencies.
* `meta`
* `passthru`
* `substitutions` Mapping of key to substitution value. Each `@key@` in the script is replaced by the corresponding value.
* `__structuredAttrs` Whether to enable `__structuredAttrs` for the hook derivation itself (not for its consumers, which are unaffected either way).
