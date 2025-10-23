# Writing Tests {#sec-writing-nixos-tests}

A NixOS test is a module that has the following structure:

```nix
{

  # One or more machines:
  nodes = {
    machine =
      { config, pkgs, ... }:
      {
        # ...
      };
    machine2 =
      { config, pkgs, ... }:
      {
        # ...
      };
    # …
  };

  testScript = ''
    Python code…
  '';
}
```

We refer to the whole test above as a test module, whereas the values
in [`nodes.<name>`](#test-opt-nodes) are NixOS modules themselves.

The option [`testScript`](#test-opt-testScript) is a piece of Python code that executes the
test (described below). During the test, it will start one or more
virtual machines, the configuration of which is described by
the option [`nodes`](#test-opt-nodes).

An example of a single-node test is
[`login.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/login.nix).
It only needs a single machine to test whether users can log in
on the virtual console, whether device ownership is correctly maintained
when switching between consoles, and so on. An interesting multi-node test is
[`nfs/simple.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/nfs/simple.nix).
It uses two client nodes to test correct locking across server crashes.

## Calling a test {#sec-calling-nixos-tests}

Tests are invoked differently depending on whether the test is part of NixOS or lives in a different project.

### Testing within NixOS {#sec-call-nixos-test-in-nixos}

Tests that are part of NixOS are added to [`nixos/tests/all-tests.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/all-tests.nix).

```nix
{ hostname = runTest ./hostname.nix; }
```

Overrides can be added by defining an anonymous module in `all-tests.nix`.

```nix
{
  hostname = runTest {
    imports = [ ./hostname.nix ];
    defaults.networking.firewall.enable = false;
  };
}
```

You can run a test with attribute name `hostname` in `nixos/tests/all-tests.nix` by invoking:

```shell
cd /my/git/clone/of/nixpkgs
nix-build -A nixosTests.hostname
```

### Testing outside the NixOS project {#sec-call-nixos-test-outside-nixos}

Outside the `nixpkgs` repository, you can use the `runNixOSTest` function from
`pkgs.testers`:

```nix
let
  pkgs = import <nixpkgs> { };

in
pkgs.testers.runNixOSTest {
  imports = [ ./test.nix ];
  defaults.services.foo.package = mypkg;
}
```

`runNixOSTest` returns a derivation that runs the test.

## Configuring the nodes {#sec-nixos-test-nodes}

There are a few special NixOS options for test VMs:

`virtualisation.memorySize`

:   The memory of the VM in MiB (1024×1024 bytes).

`virtualisation.vlans`

:   The virtual networks to which the VM is connected. See
    [`nat.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/nat.nix)
    for an example.

`virtualisation.writableStore`

:   By default, the Nix store in the VM is not writable. If you enable
    this option, a writable union file system is mounted on top of the
    Nix store to make it appear writable. This is necessary for tests
    that run Nix operations that modify the store.

For more options, see the module
[`qemu-vm.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/qemu-vm.nix).

The test script is a sequence of Python statements that perform various
actions, such as starting VMs, executing commands in the VMs, and so on.
Each virtual machine is represented as an object stored in the variable
`name` if this is also the identifier of the machine in the declarative
config. If you specified a node `nodes.machine`, the following example starts the
machine, waits until it has finished booting, then executes a command
and checks that the output is more-or-less correct:

```py
machine.start()
machine.wait_for_unit("default.target")
t.assertIn("Linux", machine.succeed("uname"), "Wrong OS")
```

The first line is technically unnecessary; machines are implicitly started
when you first execute an action on them (such as `wait_for_unit` or
`succeed`). If you have multiple machines, you can speed up the test by
starting them in parallel:

```py
start_all()
```

Under the variable `t`, all assertions from [`unittest.TestCase`](https://docs.python.org/3/library/unittest.html) are available.

If the hostname of a node contains characters that can't be used in a
Python variable name, those characters will be replaced with
underscores in the variable name, so `nodes.machine-a` will be exposed
to Python as `machine_a`.

## Machine objects {#ssec-machine-objects}

The following methods are available on machine objects:

@PYTHON_MACHINE_METHODS@

To test user units declared by `systemd.user.services` the optional
`user` argument can be used:

```py
machine.start()
machine.wait_for_x()
machine.wait_for_unit("xautolock.service", "x-session-user")
```

This applies to `systemctl`, `get_unit_info`, `wait_for_unit`,
`start_job` and `stop_job`.

For faster dev cycles it's also possible to disable the code-linters
(this shouldn't be committed though):

```nix
{
  skipLint = true;
  nodes.machine =
    { config, pkgs, ... }:
    {
      # configuration…
    };

  testScript = ''
    Python code…
  '';
}
```

This will produce a Nix warning at evaluation time. To fully disable the
linter, wrap the test script in comment directives to disable the Black
linter directly (again, don't commit this within the Nixpkgs
repository):

```nix
{
  testScript = ''
    # fmt: off
    Python code…
    # fmt: on
  '';
}
```

Similarly, the type checking of test scripts can be disabled in the following
way:

```nix
{
  skipTypeCheck = true;
  nodes.machine =
    { config, pkgs, ... }:
    {
      # configuration…
    };
}
```

## Failing tests early {#ssec-failing-tests-early}

To fail tests early when certain invariants are no longer met (instead of waiting for the build to time out), the decorator `polling_condition` is provided. For example, if we are testing a program `foo` that should not quit after being started, we might write the following:

```py
@polling_condition
def foo_running():
    machine.succeed("pgrep -x foo")


machine.succeed("foo --start")
machine.wait_until_succeeds("pgrep -x foo")

with foo_running:
    ...  # Put `foo` through its paces
```

`polling_condition` takes the following (optional) arguments:

`seconds_interval`

:   specifies how often the condition should be polled:

```py
@polling_condition(seconds_interval=10)
def foo_running():
    machine.succeed("pgrep -x foo")
```

`description`

:   is used in the log when the condition is checked. If this is not provided, the description is pulled from the docstring of the function. These two are therefore equivalent:

```py
@polling_condition
def foo_running():
    "check that foo is running"
    machine.succeed("pgrep -x foo")
```

```py
@polling_condition(description="check that foo is running")
def foo_running():
    machine.succeed("pgrep -x foo")
```

## Adding Python packages to the test script {#ssec-python-packages-in-test-script}

When additional Python libraries are required in the test script, they can be
added using the parameter `extraPythonPackages`. For example, you could add
`numpy` like this:

```nix
{
  extraPythonPackages = p: [ p.numpy ];

  nodes = { };

  # Type checking on extra packages doesn't work yet
  skipTypeCheck = true;

  testScript = ''
    import numpy as np
    assert str(np.zeros(4)) == "[0. 0. 0. 0.]"
  '';
}
```

In that case, `numpy` is chosen from the generic `python3Packages`.

## Overriding a test {#sec-override-nixos-test}

The NixOS test framework returns tests with multiple overriding methods.

`overrideTestDerivation` *function*
:   Like applying `overrideAttrs` on the [test](#test-opt-test) derivation.

    This is a convenience for `extend` with an override on the [`rawTestDerivationArg`](#test-opt-rawTestDerivationArg) option.

    *function*
    :   An extension function, e.g. `finalAttrs: prevAttrs: { /* … */ }`, the result of which is passed to [`mkDerivation`](https://nixos.org/manual/nixpkgs/stable/#sec-using-stdenv).
        Just as with `overrideAttrs`, an abbreviated form can be used, e.g. `prevAttrs: { /* … */ }` or even `{ /* … */ }`.
        See [`lib.extends`](https://nixos.org/manual/nixpkgs/stable/#function-library-lib.fixedPoints.extends).

`extendNixOS { module = ` *module* `; specialArgs = ` *specialArgs* `; }`
:   Evaluates the test with additional NixOS modules and/or arguments.

    `module`
    :   A NixOS module to add to all the nodes in the test. Sets test option [`extraBaseModules`](#test-opt-extraBaseModules).

    `specialArgs`
    :   An attribute set of arguments to pass to all NixOS modules. These override the existing arguments, as well as any `_module.args.<name>` that the modules may define. Sets test option [`node.specialArgs`](#test-opt-node.specialArgs).

    This is a convenience function for `extend` that overrides the aforementioned test options.

    :::{.example #ex-nixos-test-extendNixOS}

    # Using extendNixOS in `passthru.tests` to make `(openssh.tests.overrideAttrs f).tests.nixos` coherent

    ```nix
    mkDerivation (finalAttrs: {
      # …
      passthru = {
        tests = {
          nixos = nixosTests.openssh.extendNixOS {
            module = {
              services.openssh.package = finalAttrs.finalPackage;
            };
          };
        };
      };
    })
    ```
    :::

`extend { modules = ` *modules* `; specialArgs = ` *specialArgs* `; }`
:   Adds new `nixosTest` modules and/or module arguments to the test, which are evaluated together with the existing modules and [built-in options](#sec-test-options-reference).

    If you're only looking to extend the _NixOS_ configurations of the test, and not something else about the test, you may use the `extendNixOS` convenience function instead.

    `modules`
    :   A list of modules to add to the test. These are added to the existing modules and then [evaluated](https://nixos.org/manual/nixpkgs/stable/index.html#module-system-lib-evalModules) together.

    `specialArgs`
    :   An attribute of arguments to pass to the test. These override the existing arguments, as well as any `_module.args.<name>` that the modules may define. See [`evalModules`/`specialArgs`](https://nixos.org/manual/nixpkgs/stable/#module-system-lib-evalModules-param-specialArgs).

## Test Options Reference {#sec-test-options-reference}

The following options can be used when writing tests.

```{=include=} options
id-prefix: test-opt-
list-id: test-options-list
source: @NIXOS_TEST_OPTIONS_JSON@
```

## Accessing VMs in the sandbox with SSH {#sec-test-sandbox-breakpoint}

::: {.note}
For debugging with SSH access into the machines, it's recommended to try using
[the interactive driver](#sec-running-nixos-tests-interactively) with its
[SSH backdoor](#sec-nixos-test-ssh-access) first.

This feature is mostly intended to debug flaky test failures that aren't
reproducible elsewhere.
:::

As explained in [](#sec-nixos-test-ssh-access), it's possible to configure an
SSH backdoor based on AF_VSOCK. This can be used to SSH into a VM of a running
build in a sandbox.

This can be done when something in the test fails, e.g.

```nix
{
  nodes.machine = { };

  sshBackdoor.enable = true;
  enableDebugHook = true;

  testScript = ''
    start_all()
    machine.succeed("false") # this will fail
  '';
}
```

For the AF_VSOCK feature to work, `/dev/vhost-vsock` is needed in the sandbox
which can be done with e.g.

```
nix-build -A nixosTests.foo --option sandbox-paths /dev/vhost-vsock
```

This will halt the test execution on a test-failure and print instructions
on how to enter the sandbox shell of the VM test. Inside, one can log into
e.g. `machine` with

```
ssh -F ./ssh_config vsock/3
```

As described in [](#sec-nixos-test-ssh-access), the numbers for vsock start at
`3` instead of `1`. So the first VM in the network (sorted alphabetically) can
be accessed with `vsock/3`.

Alternatively, it's possible to explicitly set a breakpoint with
`debug.breakpoint()`. This also has the benefit, that one can step through
`testScript` with `pdb` like this:

```
$ sudo /nix/store/eeeee-attach <id>
bash# telnet 127.0.0.1 4444
pdb$ …
```
