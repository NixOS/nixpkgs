# Running Tests interactively {#sec-running-nixos-tests-interactively}

The test itself can be run interactively. This is particularly useful
when developing or debugging a test:

```ShellSession
$ nix-build nixos/tests/login.nix -A driverInteractive
$ ./result/bin/nixos-test-driver
starting VDE switch for network 1
>
```

You can then take any Python statement, e.g.

```py
> start_all()
> test_script()
> machine.succeed("touch /tmp/foo")
> print(machine.succeed("pwd")) # Show stdout of command
```

The function `test_script` executes the entire test script and drops you
back into the test driver command line upon its completion. This allows
you to inspect the state of the VMs after the test (e.g. to debug the
test script).

To just start and experiment with the VMs, run:

```ShellSession
$ nix-build nixos/tests/login.nix -A driverInteractive
$ ./result/bin/nixos-run-vms
```

The script `nixos-run-vms` starts the virtual machines defined by test.

You can re-use the VM states coming from a previous run by setting the
`--keep-vm-state` flag.

```ShellSession
$ ./result/bin/nixos-run-vms --keep-vm-state
```

The machine state is stored in the `$TMPDIR/vm-state-machinename`
directory.
