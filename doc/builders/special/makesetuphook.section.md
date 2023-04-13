# pkgs.makeSetupHook {#sec-pkgs.makeSetupHook}

`pkgs.makeSetupHook` is a builder that produces hooks that go in to `nativeBuildInputs`

## Usage {#sec-pkgs.makeSetupHook-usage}

```nix
pkgs.makeSetupHook {
  name = "something-hook";
  propagatedBuildInputs = [ pkgs.commandsomething ];
  depsTargetTargetPropagated = [ pkgs.libsomething ];
} ./script.sh
```

#### setup hook that depends on the hello package and runs hello and @shell@ is substituted with path to bash {#sec-pkgs.makeSetupHook-usage-example}

```nix
pkgs.makeSetupHook {
    name = "run-hello-hook";
    propagatedBuildInputs = [ pkgs.hello ];
    substitutions = { shell = "${pkgs.bash}/bin/bash"; };
    passthru.tests.greeting = callPackage ./test { };
    meta.platforms = lib.platforms.linux;
} (writeScript "run-hello-hook.sh" ''
    #!@shell@
    hello
'')
```

## Attributes {#sec-pkgs.makeSetupHook-attributes}

* `name` Set the name of the hook.
* `propagatedBuildInputs` Runtime dependencies (such as binaries) of the hook.
* `depsTargetTargetPropagated` Non-binary dependencies.
* `meta`
* `passthru`
* `substitutions` Variables for `substituteAll`
