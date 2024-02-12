# Writing Tests {#sec-writing-nixos-tests}

A NixOS test is a module that has the following structure:

```nix
{

  # One or more machines:
  nodes =
    { machine =
        { config, pkgs, ... }: { … };
      machine2 =
        { config, pkgs, ... }: { … };
      …
    };

  testScript =
    ''
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
  hostname = runTest ./hostname.nix;
```

Overrides can be added by defining an anonymous module in `all-tests.nix`.

```nix
  hostname = runTest {
    imports = [ ./hostname.nix ];
    defaults.networking.firewall.enable = false;
  };
```

You can run a test with attribute name `hostname` in `nixos/tests/all-tests.nix` by invoking:

```shell
cd /my/git/clone/of/nixpkgs
nix-build -A nixosTests.hostname
```

### Testing outside the NixOS project {#sec-call-nixos-test-outside-nixos}

Outside the `nixpkgs` repository, you can instantiate the test by first importing the NixOS library,

```nix
let nixos-lib = import (nixpkgs + "/nixos/lib") { };
in

nixos-lib.runTest {
  imports = [ ./test.nix ];
  hostPkgs = pkgs;  # the Nixpkgs package set used outside the VMs
  defaults.services.foo.package = mypkg;
}
```

`runTest` returns a derivation that runs the test.

## Configuring the nodes {#sec-nixos-test-nodes}

There are a few special NixOS options for test VMs:

`virtualisation.memorySize`

:   The memory of the VM in megabytes.

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
if not "Linux" in machine.succeed("uname"):
  raise Exception("Wrong OS")
```

The first line is technically unnecessary; machines are implicitly started
when you first execute an action on them (such as `wait_for_unit` or
`succeed`). If you have multiple machines, you can speed up the test by
starting them in parallel:

```py
start_all()
```

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
    { configuration…
    };

  testScript =
    ''
      Python code…
    '';
}
```

This will produce a Nix warning at evaluation time. To fully disable the
linter, wrap the test script in comment directives to disable the Black
linter directly (again, don't commit this within the Nixpkgs
repository):

```nix
  testScript =
    ''
      # fmt: off
      Python code…
      # fmt: on
    '';
```

Similarly, the type checking of test scripts can be disabled in the following
way:

```nix
{
  skipTypeCheck = true;
  nodes.machine =
    { config, pkgs, ... }:
    { configuration…
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
    assert str(np.zeros(4) == "array([0., 0., 0., 0.])")
  '';
}
```

In that case, `numpy` is chosen from the generic `python3Packages`.

## Test Options Reference {#sec-test-options-reference}

The following options can be used when writing tests.

```{=include=} options
id-prefix: test-opt-
list-id: test-options-list
source: @NIXOS_TEST_OPTIONS_JSON@
```
