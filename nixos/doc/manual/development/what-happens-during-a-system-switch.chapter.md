# What happens during a system switch? {#sec-switching-systems}

Running `nixos-rebuild switch` is one of the more common tasks under NixOS.
This chapter explains some of the internals of this command to make it simpler
for new module developers to configure their units correctly and to make it
easier to understand what is happening and why for curious administrators.

`nixos-rebuild`, like many deployment solutions, calls `switch-to-configuration`
which resides in a NixOS system at `$out/bin/switch-to-configuration`. The
script is called with the action that is to be performed like `switch`, `test`,
`boot`. There is also the `dry-activate` action which does not really perform
the actions but rather prints what it would do if you called it with `test`.
This feature can be used to check what service states would be changed if the
configuration was switched to.

If the action is `switch` or `boot`, the bootloader is updated first so the
configuration will be the next one to boot. Unless `NIXOS_NO_SYNC` is set to
`1`, `/nix/store` is synced to disk.

If the action is `switch` or `test`, the currently running system is inspected
and the actions to switch to the new system are calculated. This process takes
two data sources into account: `/etc/fstab` and the current systemd status.
Mounts and swaps are read from `/etc/fstab` and the corresponding actions are
generated. If the options of a mount are modified, for example, the proper `.mount`
unit is reloaded (or restarted if anything else changed and it's neither the root
mount or the nix store). The current systemd state is inspected, the difference
between the current system and the desired configuration is calculated and
actions are generated to get to this state. There are a lot of nuances that can
be controlled by the units which are explained here.

After calculating what should be done, the actions are carried out. The order
of actions is always the same:
- Stop units (`systemctl stop`)
- Run activation script (`$out/activate`)
- See if the activation script requested more units to restart
- Restart systemd if needed (`systemd daemon-reexec`)
- Forget about the failed state of units (`systemctl reset-failed`)
- Reload systemd (`systemctl daemon-reload`)
- Reload systemd user instances (`systemctl --user daemon-reload`)
- Reactivate sysinit (`systemctl restart sysinit-reactivation.target`)
- Reload units (`systemctl reload`)
- Restart units (`systemctl restart`)
- Start units (`systemctl start`)
- Inspect what changed during these actions and print units that failed and
  that were newly started

By default, some units are filtered from the outputs to make it less spammy.
This can be disabled for development or testing by setting the environment variable
`STC_DISPLAY_ALL_UNITS=1`

Most of these actions are either self-explaining but some of them have to do
with our units or the activation script. For this reason, these topics are
explained in the next sections.

```{=include=} sections
unit-handling.section.md
activation-script.section.md
non-switchable-systems.section.md
etc-overlay.section.md
```
