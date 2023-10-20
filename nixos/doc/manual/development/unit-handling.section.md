# Unit handling {#sec-unit-handling}

To find out which units to start/stop/restart/reload, the script first checks
the current state of the system, similar to what `systemctl
list-units` shows. For each of the units, the script performs the following
checks:

- Does the unit file still exist in the new system? If not, **stop** the service
  unless it sets `X-StopOnRemoval` in the `[Unit]` section to `false`.

- Is it a `.target` unit? If so, **start** it, unless it sets
  `RefuseManualStart` in the `[Unit]` section to `true`, or `X-OnlyManualStart`
  in the `[Unit]` section to `true`. Also **stop** the unit again unless it
  sets `X-StopOnReconfiguration` to `false`.

- Are the contents of the unit files different? They are compared by parsing
  them and comparing their contents. If they are different, but only
  `X-Reload-Triggers` in the `[Unit]` section is changed, **reload** the unit.
  The NixOS module system allows setting these triggers with the option
  [systemd.services.\<name\>.reloadTriggers](#opt-systemd.services). There are
  some additional keys in the `[Unit]` section which are also ignored. If the
  unit files differ in any way, the following actions are taken:

  - `.path` and `.slice` units will be ignored. There is no need to restart them,
    as changes to their values will be applied by systemd when systemd is
    reloaded.

  - `.mount` units will be **reload**ed if only their `Options` changed. If anything
    else changed (like `What`), they will be **restart**ed unless they are the mount
    unit for `/` or `/nix` in which case they will be reloaded to prevent the system
    from crashing. Note that this is the case for `.mount` units and not for
    mounts from `/etc/fstab`. These are explained in [](#sec-switching-systems).

  - `.socket` units will currently be ignored. This wilwill fixed at a later
    point.

  - The remaining units (mostly `.service` units) will then be **reload**ed if
    `X-ReloadIfChanged` in the `[Service]` section is set to `true` (exposed
    via [systemd.services.\<name\>.reloadIfChanged](#opt-systemd.services)).
    A small exception is made for units that have been deactivated in the meantime,
    for example because they require a unit that was previously stopped. These
    will be **start**ed instead of reloaded.

  - If the reload flag is not set, a few flags decide whether the unit will be
    skipped. These flags are `X-RestartIfChanged` in the `[Service]` section
    (exposed via
    [systemd.services.\<name\>.restartIfChanged](#opt-systemd.services)),
    `RefuseManualStop` in the `[Unit]` section, and `X-OnlyManualStart` in the
    `[Unit]` section.

  - Further behaviour depends on the unit having `X-StopIfChanged` in the
    `[Service]` section set to `true` (exposed via
    [systemd.services.\<name\>.stopIfChanged](#opt-systemd.services)). This is
    set to `true` by default, and must be explicitly disabled if not desired.
    If the flag is enabled, the unit will be **stop**ped and then **start**ed. If
    not, the unit will be **restart**ed. The purpose of the flag is to ensure that
    the new unit is never run in the old environment, which is still in place
    before the activation script is run. This behaviour is different if the
    service is socket-activated, as described in the following step.

  - The last thing that is taken into account is whether the unit is a service
    and socket-activated. If `X-StopIfChanged` is **not** set, the service
    will be **restart**ed with the others. If it is set, both the service and the
    socket will be **stop**ped, and the socket will be **start**ed, leaving socket
    activation to start the service when it's needed.
