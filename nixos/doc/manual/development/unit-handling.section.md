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
  [systemd.services.\<name\>.reloadTriggers](#opt-systemd.services). If the
  unit files differ in any way, the following actions are performed:

  - `.path` and `.slice` units are ignored. There is no need to restart them
    since changes in their values are applied by systemd when systemd is
    reloaded.

  - `.mount` units are **reload**ed. These mostly come from the `/etc/fstab`
    parser.

  - `.socket` units are currently ignored. This is to be fixed at a later
    point.

  - The rest of the units (mostly `.service` units) are then **reload**ed if
    `X-ReloadIfChanged` in the `[Service]` section is set to `true` (exposed
    via [systemd.services.\<name\>.reloadIfChanged](#opt-systemd.services)).

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
