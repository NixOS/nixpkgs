# Unit handling {#sec-unit-handling}

To figure out what units need to be started/stopped/restarted/reloaded, the
script first checks the current state of the system, similar to what `systemctl
list-units` shows. For each of the units, the script goes through the following
checks:

- Is the unit file still in the new system? If not, **stop** the service unless
  it sets `X-StopOnRemoval` in the `[Unit]` section to `false`.

- Is it a `.target` unit? If so, **start** it unless it sets
  `RefuseManualStart` in the `[Unit]` section to `true` or `X-OnlyManualStart`
  in the `[Unit]` section to `true`. Also **stop** the unit again unless it
  sets `X-StopOnReconfiguration` to `false`.

- Are the contents of the unit files different? They are compared by parsing
  them and comparing their contents. If they are different but only
  `X-Reload-Triggers` in the `[Unit]` section is changed, **reload** the unit.
  The NixOS module system allows setting these triggers with the option
  [systemd.services.\<name\>.reloadTriggers](#opt-systemd.services). There are
  some additional keys in the `[Unit]` section that are ignored as well. If the
  unit files differ in any way, the following actions are performed:

  - `.path` and `.slice` units are ignored. There is no need to restart them
    since changes in their values are applied by systemd when systemd is
    reloaded.

  - `.mount` units are **reload**ed if only their `Options` changed. If anything
    else changed (like `What`), they are **restart**ed unless they are the mount
    unit for `/` or `/nix` in which case they are reloaded to prevent the system
    from crashing. Note that this is the case for `.mount` units and not for
    mounts from `/etc/fstab`. These are explained in [](#sec-switching-systems).

  - `.socket` units are currently ignored. This is to be fixed at a later
    point.

  - The rest of the units (mostly `.service` units) are then **reload**ed if
    `X-ReloadIfChanged` in the `[Service]` section is set to `true` (exposed
    via [systemd.services.\<name\>.reloadIfChanged](#opt-systemd.services)).
    A little exception is done for units that were deactivated in the meantime,
    for example because they require a unit that got stopped before. These
    are **start**ed instead of reloaded.

  - If the reload flag is not set, some more flags decide if the unit is
    skipped. These flags are `X-RestartIfChanged` in the `[Service]` section
    (exposed via
    [systemd.services.\<name\>.restartIfChanged](#opt-systemd.services)),
    `RefuseManualStop` in the `[Unit]` section, and `X-OnlyManualStart` in the
    `[Unit]` section.

  - Further behavior depends on the unit having `X-StopIfChanged` in the
    `[Service]` section set to `true` (exposed via
    [systemd.services.\<name\>.stopIfChanged](#opt-systemd.services)). This is
    set to `true` by default and must be explicitly turned off if not wanted.
    If the flag is enabled, the unit is **stop**ped and then **start**ed. If
    not, the unit is **restart**ed. The goal of the flag is to make sure that
    the new unit never runs in the old environment which is still in place
    before the activation script is run. This behavior is different when the
    service is socket-activated, as outlined in the following steps.

  - The last thing that is taken into account is whether the unit is a service
    and socket-activated. If `X-StopIfChanged` is **not** set, the service
    is **restart**ed with the others. If it is set, both the service and the
    socket are **stop**ped and the socket is **start**ed, leaving socket
    activation to start the service when it's needed.

## Sysinit reactivation {#sec-sysinit-reactivation}

[`sysinit.target`](https://www.freedesktop.org/software/systemd/man/latest/systemd.special.html#sysinit.target)
is a systemd target that encodes system initialization (i.e. early startup). A
few units that need to run very early in the bootup process are ordered to
finish before this target is reached. Probably the most notable one of these is
`systemd-tmpfiles-setup.service`. We will refer to these units as "sysinit
units".

"Normal" systemd units, by default, are ordered AFTER `sysinit.target`. In
other words, these "normal" units expect all services ordered before
`sysinit.target` to have finished without explicitly declaring this dependency
relationship for each dependency. See the [systemd
bootup](https://www.freedesktop.org/software/systemd/man/latest/bootup.html)
for more details on the bootup process.

When restarting both a unit ordered before `sysinit.target` as well as one
after, this presents a problem because they would be started at the same time
as they do not explicitly declare their dependency relations.

To solve this, NixOS has an artificial `sysinit-reactivation.target` which
allows you to ensure that services ordered before `sysinit.target` are
restarted correctly. This applies both to the ordering between these sysinit
services as well as ensuring that sysinit units are restarted before "normal"
units.

To make an existing sysinit service restart correctly during system switch, you
have to declare:

```nix
{
  systemd.services.my-sysinit = {
    requiredBy = [ "sysinit-reactivation.target" ];
    before = [ "sysinit-reactivation.target" ];
    restartTriggers = [ config.environment.etc."my-sysinit.d".source ];
  };
}
```

You need to configure appropriate `restartTriggers` specific to your service.
