# Changing the Configuration {#sec-changing-config}

The file `/etc/nixos/configuration.nix` contains the current
configuration of your machine. Whenever you've [changed
something](#ch-configuration) in that file, you should do

```ShellSession
# nixos-rebuild switch
```

to build the new configuration, make it the default configuration for
booting, and try to realise the configuration in the running system
(e.g., by restarting system services).

::: {.warning}
This command doesn't start/stop [user services](#opt-systemd.user.services)
automatically. `nixos-rebuild` only runs a `daemon-reload` for each user with running
user services.
:::

::: {.warning}
These commands must be executed as root, so you should either run them
from a root shell or by prefixing them with `sudo -i`.
:::

You can also do

```ShellSession
# nixos-rebuild test
```

to build the configuration and switch the running system to it, but
without making it the boot default. So if (say) the configuration locks
up your machine, you can just reboot to get back to a working
configuration.

There is also

```ShellSession
# nixos-rebuild boot
```

to build the configuration and make it the boot default, but not switch
to it now (so it will only take effect after the next reboot).

You can make your configuration show up in a different submenu of the
GRUB 2 boot screen by giving it a different *profile name*, e.g.

```ShellSession
# nixos-rebuild switch -p test
```

which causes the new configuration (and previous ones created using
`-p test`) to show up in the GRUB submenu "NixOS - Profile 'test'".
This can be useful to separate test configurations from "stable"
configurations.

A repl, or read-eval-print loop, is also available. You can inspect your configuration and use the Nix language with

```ShellSession
# nixos-rebuild repl
```

Your configuration is loaded into the `config` variable. Use tab for autocompletion, use the `:r` command to reload the configuration files. See `:?` or [`nix repl` in the Nix manual](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-repl.html) to learn more.

Finally, you can do

```ShellSession
$ nixos-rebuild build
```

to build the configuration but nothing more. This is useful to see
whether everything compiles cleanly.

If you have a machine that supports hardware virtualisation, you can
also test the new configuration in a sandbox by building and running a
QEMU *virtual machine* that contains the desired configuration. Just do

```ShellSession
$ nixos-rebuild build-vm
$ ./result/bin/run-*-vm
```

The VM does not have any data from your host system, so your existing
user accounts and home directories will not be available unless you have
set `mutableUsers = false`. Another way is to temporarily add the
following to your configuration:

```nix
{ users.users.your-user.initialHashedPassword = "test"; }
```

*Important:* delete the \$hostname.qcow2 file if you have started the
virtual machine at least once without the right users, otherwise the
changes will not get picked up. You can forward ports on the host to the
guest. For instance, the following will forward host port 2222 to guest
port 22 (SSH):

```ShellSession
$ QEMU_NET_OPTS="hostfwd=tcp:127.0.0.1:2222-:22" ./result/bin/run-*-vm
```

allowing you to log in via SSH (assuming you have set the appropriate
passwords or SSH authorized keys):

```ShellSession
$ ssh -p 2222 localhost
```

Such port forwardings connect via the VM's virtual network interface.
Thus they cannot connect to ports that are only bound to the VM's
loopback interface (`127.0.0.1`), and the VM's NixOS firewall
must be configured to allow these connections.
