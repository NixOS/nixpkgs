# Writing Tests {#sec-writing-nixos-tests}

A NixOS test is a Nix expression that has the following structure:

```nix
import ./make-test-python.nix {

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

The attribute `testScript` is a bit of Python code that executes the
test (described below). During the test, it will start one or more
virtual machines, the configuration of which is described by
the attribute `nodes`.

An example of a single-node test is
[`login.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/login.nix).
It only needs a single machine to test whether users can log in
on the virtual console, whether device ownership is correctly maintained
when switching between consoles, and so on. An interesting multi-node test is
[`nfs/simple.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/nfs/simple.nix).
It uses two client nodes to test correct locking across server crashes.

There are a few special NixOS configuration options for test VMs:

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

## Machine objects {#ssec-machine-objects}

The following methods are available on machine objects:

`start`

:   Start the virtual machine. This method is asynchronous --- it does
    not wait for the machine to finish booting.

`shutdown`

:   Shut down the machine, waiting for the VM to exit.

`crash`

:   Simulate a sudden power failure, by telling the VM to exit
    immediately.

`block`

:   Simulate unplugging the Ethernet cable that connects the machine to
    the other machines.

`unblock`

:   Undo the effect of `block`.

`screenshot`

:   Take a picture of the display of the virtual machine, in PNG format.
    The screenshot is linked from the HTML log.

`get_screen_text_variants`

:   Return a list of different interpretations of what is currently
    visible on the machine\'s screen using optical character
    recognition. The number and order of the interpretations is not
    specified and is subject to change, but if no exception is raised at
    least one will be returned.

    ::: {.note}
    This requires passing `enableOCR` to the test attribute set.
    :::

`get_screen_text`

:   Return a textual representation of what is currently visible on the
    machine\'s screen using optical character recognition.

    ::: {.note}
    This requires passing `enableOCR` to the test attribute set.
    :::

`send_monitor_command`

:   Send a command to the QEMU monitor. This is rarely used, but allows
    doing stuff such as attaching virtual USB disks to a running
    machine.

`send_key`

:   Simulate pressing keys on the virtual keyboard, e.g.,
    `send_key("ctrl-alt-delete")`.

`send_chars`

:   Simulate typing a sequence of characters on the virtual keyboard,
    e.g., `send_chars("foobar\n")` will type the string `foobar`
    followed by the Enter key.

`send_console`

:   Send keys to the kernel console. This allows interaction with the systemd
    emergency mode, for example. Takes a string that is sent, e.g.,
    `send_console("\n\nsystemctl default\n")`.

`execute`

:   Execute a shell command, returning a list `(status, stdout)`.

    Commands are run with `set -euo pipefail` set:

    -   If several commands are separated by `;` and one fails, the
        command as a whole will fail.

    -   For pipelines, the last non-zero exit status will be returned
        (if there is one; otherwise zero will be returned).

    -   Dereferencing unset variables fails the command.

    -   It will wait for stdout to be closed.

    If the command detaches, it must close stdout, as `execute` will wait
    for this to consume all output reliably. This can be achieved by
    redirecting stdout to stderr `>&2`, to `/dev/console`, `/dev/null` or
    a file. Examples of detaching commands are `sleep 365d &`, where the
    shell forks a new process that can write to stdout and `xclip -i`, where
    the `xclip` command itself forks without closing stdout.

    Takes an optional parameter `check_return` that defaults to `True`.
    Setting this parameter to `False` will not check for the return code
    and return -1 instead. This can be used for commands that shut down
    the VM and would therefore break the pipe that would be used for
    retrieving the return code.

    A timeout for the command can be specified (in seconds) using the optional
    `timeout` parameter, e.g., `execute(cmd, timeout=10)` or
    `execute(cmd, timeout=None)`. The default is 900 seconds.

`succeed`

:   Execute a shell command, raising an exception if the exit status is
    not zero, otherwise returning the standard output. Similar to `execute`,
    except that the timeout is `None` by default. See `execute` for details on
    command execution.

`fail`

:   Like `succeed`, but raising an exception if the command returns a zero
    status.

`wait_until_succeeds`

:   Repeat a shell command with 1-second intervals until it succeeds.
    Has a default timeout of 900 seconds which can be modified, e.g.
    `wait_until_succeeds(cmd, timeout=10)`. See `execute` for details on
    command execution.

`wait_until_fails`

:   Like `wait_until_succeeds`, but repeating the command until it fails.

`wait_for_unit`

:   Wait until the specified systemd unit has reached the "active"
    state.

`wait_for_file`

:   Wait until the specified file exists.

`wait_for_open_port`

:   Wait until a process is listening on the given TCP port (on
    `localhost`, at least).

`wait_for_closed_port`

:   Wait until nobody is listening on the given TCP port.

`wait_for_x`

:   Wait until the X11 server is accepting connections.

`wait_for_text`

:   Wait until the supplied regular expressions matches the textual
    contents of the screen by using optical character recognition (see
    `get_screen_text` and `get_screen_text_variants`).

    ::: {.note}
    This requires passing `enableOCR` to the test attribute set.
    :::

`wait_for_console_text`

:   Wait until the supplied regular expressions match a line of the
    serial console output. This method is useful when OCR is not
    possibile or accurate enough.

`wait_for_window`

:   Wait until an X11 window has appeared whose name matches the given
    regular expression, e.g., `wait_for_window("Terminal")`.

`copy_from_host`

:   Copies a file from host to machine, e.g.,
    `copy_from_host("myfile", "/etc/my/important/file")`.

    The first argument is the file on the host. The file needs to be
    accessible while building the nix derivation. The second argument is
    the location of the file on the machine.

`systemctl`

:   Runs `systemctl` commands with optional support for
    `systemctl --user`

    ```py
    machine.systemctl("list-jobs --no-pager") # runs `systemctl list-jobs --no-pager`
    machine.systemctl("list-jobs --no-pager", "any-user") # spawns a shell for `any-user` and runs `systemctl --user list-jobs --no-pager`
    ```

`shell_interact`

:   Allows you to directly interact with the guest shell. This should
    only be used during test development, not in production tests.
    Killing the interactive session with `Ctrl-d` or `Ctrl-c` also ends
    the guest session.

`console_interact`

:   Allows you to directly interact with QEMU's stdin. This should
    only be used during test development, not in production tests.
    Output from QEMU is only read line-wise. `Ctrl-c` kills QEMU and
    `Ctrl-d` closes console and returns to the test runner.

To test user units declared by `systemd.user.services` the optional
`user` argument can be used:

```py
machine.start()
machine.wait_for_x()
machine.wait_for_unit("xautolock.service", "x-session-user")
```

This applies to `systemctl`, `get_unit_info`, `wait_for_unit`,
`start_job` and `stop_job`.

For faster dev cycles it\'s also possible to disable the code-linters
(this shouldn\'t be commited though):

```nix
import ./make-test-python.nix {
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
linter directly (again, don\'t commit this within the Nixpkgs
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
import ./make-test-python.nix {
  skipTypeCheck = true;
  nodes.machine =
    { config, pkgs, ... }:
    { configuration…
    };
}
```

## Failing tests early {#ssec-failing-tests-early}

To fail tests early when certain invariables are no longer met (instead of waiting for the build to time out), the decorator `polling_condition` is provided. For example, if we are testing a program `foo` that should not quit after being started, we might write the following:

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

:
    specifies how often the condition should be polled:

    ```py
    @polling_condition(seconds_interval=10)
    def foo_running():
        machine.succeed("pgrep -x foo")
    ```

`description`

:
    is used in the log when the condition is checked. If this is not provided, the description is pulled from the docstring of the function. These two are therefore equivalent:

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
import ./make-test-python.nix
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
