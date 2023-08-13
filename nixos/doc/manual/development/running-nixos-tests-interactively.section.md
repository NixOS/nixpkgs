# Running Tests interactively {#sec-running-nixos-tests-interactively}

The test itself can be run interactively. This is particularly useful
when developing or debugging a test:

```ShellSession
$ nix-build . -A nixosTests.login.driverInteractive
$ ./result/bin/nixos-test-driver
[...]
>>>
```

You can then take any Python statement, e.g.

```py
>>> start_all()
>>> test_script()
>>> machine.succeed("touch /tmp/foo")
>>> print(machine.succeed("pwd")) # Show stdout of command
```

The function `test_script` executes the entire test script and drops you
back into the test driver command line upon its completion. This allows
you to inspect the state of the VMs after the test (e.g. to debug the
test script).

## Shell access in interactive mode {#sec-nixos-test-shell-access}

The function `<yourmachine>.shell_interact()` grants access to a shell running
inside a virtual machine. To use it, replace `<yourmachine>` with the name of a
virtual machine defined in the test, for example: `machine.shell_interact()`.
Keep in mind that this shell may not display everything correctly as it is
running within an interactive Python REPL, and logging output from the virtual
machine may overwrite input and output from the guest shell:

```py
>>> machine.shell_interact()
machine: Terminal is ready (there is no initial prompt):
$ hostname
machine
```

As an alternative, you can proxy the guest shell to a local TCP server by first
starting a TCP server in a terminal using the command:

```ShellSession
$ socat 'READLINE,PROMPT=$ ' tcp-listen:4444,reuseaddr`
```

In the terminal where the test driver is running, connect to this server by
using:

```py
>>> machine.shell_interact("tcp:127.0.0.1:4444")
```

Once the connection is established, you can enter commands in the socat terminal
where socat is running.

## Reuse VM state {#sec-nixos-test-reuse-vm-state}

You can re-use the VM states coming from a previous run by setting the
`--keep-vm-state` flag.

```ShellSession
$ ./result/bin/nixos-test-driver --keep-vm-state
```

The machine state is stored in the `$TMPDIR/vm-state-machinename`
directory.

## Interactive-only test configuration {#sec-nixos-test-interactive-configuration}

The `.driverInteractive` attribute combines the regular test configuration with
definitions from the [`interactive` submodule](#test-opt-interactive). This gives you
a more usable, graphical, but slightly different configuration.

You can add your own interactive-only test configuration by adding extra
configuration to the [`interactive` submodule](#test-opt-interactive).

To interactively run only the regular configuration, build the `<test>.driver` attribute
instead, and call it with the flag `result/bin/nixos-test-driver --interactive`.
