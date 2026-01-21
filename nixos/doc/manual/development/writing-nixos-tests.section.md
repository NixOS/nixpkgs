# Writing Tests {#sec-writing-nixos-tests}

A NixOS test is a module that has the following structure:

```nix
{
  # QEMU virtual machines:
  nodes = {
    vm1 =
      { config, pkgs, ... }:
      {
        # ...
      };
    vm2 =
      { config, pkgs, ... }:
      {
        # ...
      };
    # …
  };

  # systemd-nspawn containers:
  containers = {
    container1 =
      { config, pkgs, ... }:
      {
        # ...
      };
    container2 =
      { config, pkgs, ... }:
      {
        # ...
      };
  };

  testScript = ''
    Python code…
  '';
}
```

We refer to the whole test above as a test module, whereas the values
in [`nodes.<name>`](#test-opt-nodes) and [`containers.<name>`](#test-opt-containers)
are NixOS modules themselves.

The option [`testScript`](#test-opt-testScript) is a piece of Python code that executes the
test (described [below](#ssec-test-script)). During the test, it will start one or more
virtual machines and/or `systemd-nspawn` containers, the configuration of which is described by
the options [`nodes`](#test-opt-nodes) and [`containers`](#test-opt-containers), respectively.

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

## Test machines {#ssec-nixos-test-machines}

A NixOS test usually consists of one or more test machines. Each machine is either a
QEMU virtual machine or a `systemd-nspawn` container.

QEMU virtual machines are defined in the
[`nodes`](#test-opt-nodes) attribute set, whereas `systemd-nspawn` containers are defined in the
[`containers`](#test-opt-containers) attribute set.

To set NixOS options for all machines in the test, use the attribute
[`defaults`](#test-opt-defaults). These options are applied to both virtual machines
and containers. You can set separate defaults for virtual machines and containers
using the attributes [`nodeDefaults`](#test-opt-nodeDefaults) and
[`containerDefaults`](#test-opt-containerDefaults), respectively.

### Virtual machines vs. containers {#sec-nixos-test-vms-vs-containers}

QEMU virtual machines and `systemd-nspawn` containers offer different
trade-offs which make them suitable for different use cases.

Some advantages of containers over virtual machines are:

- Containers share the kernel of the host system; they are
  significantly faster to start up than virtual machines.
- Containers are more lightweight in terms of resource usage, which
  allows running more of them in parallel on a single host.
- Containers can easily be run in virtualised environments, e.g., CI systems.
- Containers allow direct bind-mounting of host device nodes, which enables
  testing of GPU code (CUDA), for example.

Some advantages of virtual machines over containers are:

- Virtual machines run a separate kernel, which allows testing kernel features
  (kernel modules, etc.).
- Virtual machines support testing graphical applications on X11.
- Virtual machines allow testing hardened NixOS modules that use systemd's namespacing options (such as `ProtectSystem=`).
- Virtual machines allow the execution of `setuid` binaries.

Refer to the sections on [QEMU virtual machines](#ssec-nixos-test-qemu-vms)
and [systemd-nspawn containers](#ssec-nixos-test-nspawn-containers) below
for more details on configuring each type of machine.

### Configuring test machines {#sec-nixos-test-machines-config}

The following special NixOS option can be used to configure
machines in a NixOS test, whether they are virtual machines or containers:

`virtualisation.vlans`

:   The virtual networks to which the VM is connected. See
    [`nat.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/nat.nix)
    for an example.

#### Configuring `systemd-nspawn` containers {#ssec-nixos-test-nspawn-containers}

Some options are specific to `systemd-nspawn` containers:

`virtualisation.systemd-nspawn.options`

:  A list of additional command-line options to pass to
    `systemd-nspawn` when starting the container. For example, to
    bind mount a directory from the host into the container, you could
    use: `[ "--bind=/host/dir:/container/dir" ]`.

For more options, see the module
[`nspawn-container`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/nspawn-container/default.nix).

Note that the paths used in `--bind` or `--bind-ro` options have to be accessible from within the Nix sandbox.
Use the Nix option
[`sandbox-paths`](https://nix.dev/manual/nix/stable/command-ref/conf-file#conf-sandbox-paths)
and/or the module [`programs.nix-required-mounts`](#opt-programs.nix-required-mounts.enable) on the host
to add additional paths to the sandbox.

#### Configuring QEMU virtual machines {#ssec-nixos-test-qemu-vms}

Some options are specific to QEMU virtual machines:

`virtualisation.memorySize`

:   The memory of the VM in MiB (1024×1024 bytes).


`virtualisation.writableStore`

:   By default, the Nix store in the VM is not writable. If you enable
    this option, a writable union file system is mounted on top of the
    Nix store to make it appear writable. This is necessary for tests
    that run Nix operations that modify the store.

For more options, see the module
[`qemu-vm.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/qemu-vm.nix).

## Writing the test script {#ssec-test-script}

The test script is a sequence of Python statements that perform various
actions, such as starting machines, executing commands in them, and so on. For
example, if you specified a virtual machine in `nodes.machine`, there will be
a Python variable `machine` available in the test script that represents that
virtual machine. The following example would start the machine, wait until it
has finished booting, and then execute a command and check that the output is
more-or-less correct:

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

If the hostname of a machine contains characters that can't be used in a
Python variable name, those characters will be replaced with
underscores in the variable name, so `nodes.machine-a` will be exposed
to Python as `machine_a`.

### Methods available on machine objects {#ssec-machine-objects}

The following methods are available on machine objects (like `machine` in
the examples above):

@PYTHON_MACHINE_METHODS@

### Testing user units {#ssec-testing-user-units}

To test user units declared by `systemd.user.services` the optional
`user` argument can be used:

```py
machine.start()
machine.wait_for_x()
machine.wait_for_unit("xautolock.service", "x-session-user")
```

This applies to `systemctl`, `get_unit_info`, `wait_for_unit`,
`start_job` and `stop_job`.

### Failing tests early {#ssec-failing-tests-early}

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

### Adding Python packages to the test script {#ssec-python-packages-in-test-script}

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

### Linting and type checking test scripts {#ssec-test-script-checks}

Test scripts are automatically linted with
[Pyflakes](https://pypi.org/project/pyflakes/) and type-checked with
[Mypy](https://mypy.readthedocs.io/en/stable/).
If there are any linting or type checking errors, the test will
fail to evaluate.

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
    :   A NixOS module to add to all the machines in the test. Sets test option [`extraBaseModules`](#test-opt-extraBaseModules).

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

## Debugging test machines {#sec-test-sandbox-breakpoint}

You can set the [`enableDebugHook`](#test-opt-enableDebugHook) option to pause
a test on the first failure and have it print instructions on how to enter the
sandbox shell of the test. Suppose you have the following test module:

```nix
{
  name = "foo";

  nodes.machine = { };

  enableDebugHook = true;
  sshBackdoor.enable = true;

  testScript = ''
    start_all()
    machine.succeed("false") # this will fail
  '';
}
```

The test will fail with an output like this:

```
vm-test-run-foo> !!! Breakpoint reached, run 'sudo /nix/store/eeeee-attach/bin/attach <PID>'
```

You can then enter the sandbox shell:

```
$ sudo /nix/store/eeeee-attach/bin/attach <PID>
bash#
```

There, you can attach to a [`pdb`](https://docs.python.org/3/library/pdb.html) session
to step through the Python test script:

```
bash# telnet 127.0.0.1 4444
pdb$
```

Note that it is also possible to set breakpoints in the test script using `debug.breakpoint()`.

### SSH access to test VMs {#sec-test-vm-ssh-access}

::: {.note}
For debugging with SSH access into the machines, it's recommended to try using
[the interactive driver](#sec-running-nixos-tests-interactively) with its
[SSH backdoor](#sec-nixos-test-ssh-access) first.

This feature is mostly intended to debug flaky test failures that aren't
reproducible elsewhere.
:::


If you set the [`sshBackdoor.enable`](#test-opt-sshBackdoor.enable) option,
QEMU virtual machines will open an SSH backdoor based on AF_VSOCK
(see [](#sec-nixos-test-ssh-access)).
Once you are in the sandbox shell, you can access the VMs (for example, `machine`)
with SSH over vsock:

```
bash# ssh -F ./ssh_config vsock/3
```

For the AF_VSOCK feature to work, `/dev/vhost-vsock` is needed in the sandbox
which can be done with e.g.

```
nix-build -A nixosTests.foo --option sandbox-paths /dev/vhost-vsock
```

As described in [](#sec-nixos-test-ssh-access), the numbers for vsock start at
`3` instead of `1`. So the first VM in the network (sorted alphabetically) can
be accessed with `vsock/3`.

### SSH access to test containers {#sec-test-container-ssh-access}

If you set the [`sshBackdoor.enable`](#test-opt-sshBackdoor.enable) option,
each `systemd-nspawn` container will open an SSH backdoor.
Once the container starts,
it will print instructions on how to log into the container via SSH.
If the test fails,
attach to the sandbox as described above,
and then use the provided SSH command to log into the container.
For example:

```
$ sudo /nix/store/eeeee-attach <PID>
bash# ssh -o User=root 192.168.1.1
[root@machine:~]# hostname
machine
```
