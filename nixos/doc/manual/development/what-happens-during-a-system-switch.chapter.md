# What happens during a system switch? {#sec-switching-systems}

Running `nixos-rebuild switch` is one of the more common tasks in NixOS.
This chapter explains some of the internals of this command to make it easier
for new module developers to configure their units correctly, and to make it
easier for curious administrators to understand what is happening and why.

`nixos-rebuild`, like many deployment solutions, calls `switch-to-configuration`
which is located at `$out/bin/switch-to-configuration` in a NixOS system. The
script is called with the action that is to be performed, such as `switch`, `test`,
`boot`. There is also the `dry-activate` action which does not actually perform
the actions but rather prints out what it would do if you called it with `test`.
This feature can be used to check chich service states would be changed if the
configuration were switched to.

If the action is `switch` or `boot`, the boot loader will be updated first, so the
configuration will be the next one to boot. Unless `NIXOS_NO_SYNC` is set to
`1`, `/nix/store` will be synced to disk.

If the action is `switch` or `test`, the currently running system is inspected
and the actions to switch to the new system are calculated. This process takes
into account two sources of data: `/etc/fstab` and the current systemd status.
Mounts and swaps are read from `/etc/fstab` and the corresponding actions are
generated. For example, if the options of a mount are modified, the proper `.mount`
unit is reloaded (or restarted if anything else changed and it's neither the root
mount or the nix store). The current systemd state is inspected, the difference
between the current system and the desired configuration is calculated and
actions are generated to get to that state. There are many nuances that can
be controlled by the units which are explained here.

After calculating what needs to be done, the actions are executed. The order
of actions is always the same:
- Stop units (`systemctl stop`)
- Run the activation script (`$out/activate`)
- See if the activation script has requested more units to restart
- Restart systemd if necessary (`systemd daemon-reexec`)
- Forget about the failed state of all units (`systemctl reset-failed`)
- Reload systemd (`systemctl daemon-reload`)
- Reload user instances of systemd (`systemctl --user daemon-reload`)
- Set up tmpfiles (`systemd-tmpfiles --create`)
- Reload units (`systemctl reload`)
- Restart units (`systemctl restart`)
- Start units (`systemctl start`)
- Check what has changed during these actions, and print out the units that failed
- and that were newly started

Most of these actions are either self-explanatory, but some of them have to do
with our units or the activation script. For this reason, these topics are
explained in the next sections.

```{=include=} sections
unit-handling.section.md
activation-script.section.md
```
