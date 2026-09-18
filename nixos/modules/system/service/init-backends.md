# Alternative Init System Backends: What Needs to Be Brought In

What must be added to nixpkgs/NixOS so that the abstract service API can be
translated to init systems other than systemd: the required pieces, package
gaps, and how each init system maps the abstract options.

Package attribute names below refer to this nixpkgs checkout.

## Common infrastructure (any non-systemd backend)

Every backend needs pieces that NixOS currently gets for free from systemd:

- PID 1 supervision and process tracking (dinit, runit, s6 each provide it;
  systemd has no equivalent to replace)
- Power management: `poweroff`, `reboot`, `halt` must no longer shell out to
  `systemctl`. Each init system ships its own (`s6-linux-init` provides
  `s6-reboot`/`s6-poweroff`, runit provides `halt`/`reboot`/`poweroff`,
  dinit needs a small script using `reboot(2)` / `reboot(RB_POWER_OFF)`)
- Console login: `agetty` from util-linux (already in nixpkgs), spawned by
  the init system instead of `systemd-getty-generator`
- Device management: udev replacement, see "Device management" below
- D-Bus: `services.dbus` must run under the new init system. D-Bus itself is
  D-Bus; only the socket activation/daemon supervision changes. `dbus-broker`
  depends on systemd internals and must be excluded for these backends;
  `dbus-daemon` (the reference implementation) works standalone
- `nix-daemon`: a plain long-running service, no systemd dependency
- TMPFILES equivalent: each backend needs an equivalent mechanism or an
  abstraction (`systemd.tmpfiles.rules` equivalent); s6/dinit/runit can each
  run a small script; consider a portable `tmpfiles` translation later
- Logging: s6 has `s6-log`, runit has `svlogd`, dinit relies on external
  loggers. A portable `services.logging` abstraction is a candidate

## dinit

Packages available in nixpkgs: `dinit`, `bubblewrap`, `doas`,
`doas-sudo-shim`, `eudev`, `busybox`, `util-linux` (agetty).

Requirements and gaps:

- **Device management**: systemd-udevd is gone. Use `eudev` (present) or a
  small `mdev`-style daemon. `busybox mdev` works for coldplug but lacks
  hotplug event handling; `mdevd` (skaware, present in nixpkgs via
  `skawarePackages`) is the proper hotplug solution. Even better,
  `gardendevd` (present) is an udev daemon on top of mdevd explicitly built
  to replace systemd-udevd. Alternative: run `eudev` as a dinit service
- **Sandboxing / namespaces**: systemd service sandboxing
  (`PrivateTmp`, `ProtectSystem`, `NoNewPrivileges`, mount namespaces) has no
  dinit equivalent. Wrap service commands with `bubblewrap` (`bwrap`) to
  reconstruct the common sandboxing primitives. A dinit service type
  "bwrap-wrapped" (or per-service `sandbox` abstract option) runs
  `bwrap --die-with-parent --unshare-* ... argv`
- **Control groups**: dinit supports cgroups (v2 required). NixOS kernel must
  enable cgroup v2 (already the default on modern kernels) and dinit needs to
  run as PID 1 or with delegation; document `dinit`'s `--container-path` /
  cgroup delegation options in the backend
- **Privilege escalation**: `run0` (systemd-run --pty via polkit) has no
  dinit path. Use `doas` (present) for a lightweight equivalent and
  `doas-sudo-shim` for script compatibility; wire `security.sudo` to not
  depend on systemd
- **Dependency graph**: `dinit` natively understands
  `depends-on`, `after`, `before`, `waits-for` - direct translation of the
  abstract `dependencies.*` options. `requires` maps to `depends-on` +
  `restart-if-changed` semantics, `wants` maps to `waits-for` (soft)
- **Readiness**: services with `notificationProtocol.s6` need a
  `dinit`-compatible fd passing; check dinit's socket activate / readiness
  support and map `notificationProtocol.s6` accordingly

## runit

Packages available: `runit`.

Requirements and gaps:

- **Dependency graph**: runit has no native ordering; the backend must
  construct the dependency graph and start dependencies before their
  dependents. Approach: generate a `runsvdir`-booted service tree where each
  service's `run` script starts with a synchronisation step, or generate a
  boot script under `service/.dependencies` that starts `after`/`requires`
  services first.
  Candidate structure:
  - every abstract service becomes a directory under `/etc/service/<name>`
  - `dependencies.requires/wants` become `dependencies.d` entries checked by
    a generated `boot` script; `sv once` for `wants`, `sv start` blocks for
    `requires`
  - `after/before` become ordering in the generated boot script
- **Oneshot services**: map `process.type = "oneshot"` to a `run` script
  that does the work then `exit 0` (with `sv wait` semantics), and use
  `runsv`'s `./down` file to prevent immediate restart
- **Restart policy**: `restart.policy` maps to the `run` script loop in
  `runsv` (`always` = default supervised restart, `never` = `exit` after
  failure with `./down`)
- **Readiness**: `notificationProtocol.s6` cannot be used by runit
  (no readiness protocol); services relying on it need a runit-specific
  down/up check script
- **Logging**: `svlogd` per service (configurable via `runit`'s log dirs)
- **Power**: runit's `halt`/`reboot`/`poweroff` programs replace
  `systemctl poweroff` etc. Wire `systemd.shutdown` equivalents into
  activation scripts and `poweroff` bindings
- **Getty**: `agetty` services under `/etc/service/getty-tty1` etc.

## s6

Packages available: `s6`, `s6-rc`, `s6-linux-init`, `s6-linux-utils`,
`s6-portable-utils`, `s6-networking`, `execline`.

This is the most complete backend story because s6 is structure-compatible
with the abstract API:

- **Init**: `s6-linux-init` provides a working PID 1 (`s6-init`), `s6-reboot`,
  `s6-poweroff`, `s6-halt` - no systemd needed
- **Dependency graph**: `s6-rc` compiles a dependency database
  (`s6-rc-compile`) whose `after`/`type` (longrun/oneshot) and `dependencies`
  fields map 1:1 onto the abstract options
- **Readiness**: `notificationProtocol.s6` is native to s6 (`s6-notifyoncheck`)
- **Restart**: longrun services are restarted by `s6-supervise`; oneshots run
  once; `restart.policy` maps to service type choices
- **Sandboxing**: s6 has no native sandbox; same `bubblewrap` wrapper
  approach as dinit

## FreeBSD rc.d (partially implemented)

`nixos/modules/system/service/freebsd/rc-d/system.nix` is implemented: it
translates `system.services` into rc.d scripts (`/etc/rc.d/<name>`, with
PROVIDE/REQUIRE/BEFORE), `rc.conf.d` enable entries, and configData under
`/etc/freebsd/system-services/`. `dependencies.*` map to REQUIRE/BEFORE,
`process.argv` becomes `command`, `runtime.user` becomes `command_user`.
Selectable via `system.initSystem = "rc.d"`.

Still future work (out of scope for the Linux NixOS tree): the FreeBSD kernel
as a NixOS kernel, the BSD userland as the system userland, and jails support.
The rc.d backend gives the service-translation half of that story.

## Backend directory layout

```
nixos/modules/system/service/
  dinit/
    system.nix        # translates abstract services -> dinit service files
  runit/
    system.nix
  s6/
    system.nix
```

Status: **implemented**. Each backend module
(`dinit/system.nix`, `runit/system.nix`, `s6/system.nix`) declares the
portable `system.services` (via `lib.services.configure` with its own
`extraRootModules`), maps `dependencies`, `runtime`, `environment`,
`restart` and `process.*` onto its format, and exposes `configData` under a
backend-specific directory. They are opt-in imports that do not change
anything for existing configurations (systemd remains the default and is
untouched).

- dinit: `/etc/dinit.d/<name>` service files; non-root services run through
  a `setpriv` wrapper (`/etc/dinit.d/scripts/<name>`).
- runit: `/etc/runit/services/<name>` dirs (`run` + `down`); the dependency
  graph is materialized as `system.build.runitBootScript` starting services
  with `sv up` in topological order (`system.build.runitBootOrder`).
- s6: `s6-rc` source service dirs compiled with the real `s6-rc-compile`
  into `system.build.s6RcDb` (validated end-to-end); restart policies use
  `finish` scripts (exit code 125 = permanent down).

Each backend module:
translates `configData` to its own configuration
directory, and maps `dependencies`/`runtime`/`environment`/`restart`/
`process.*` onto the backend's format.

## Toggle design

One option, e.g. `system.initSystem = lib.mkOption { type = enum [
"systemd" "dinit" "runit" "s6" ]; default = "systemd"; }`, gates which
backend module is imported (`imports = [ ./${cfg.initSystem}/system.nix ]`).
All existing NixOS services keep using `systemd.services`; the systemd
backend remains authoritative for them. Only when a backend other than
systemd is chosen does the translation of `system.services` switch,
alongside a migration shim that intercepts systemd-facing calls.

## Package count / build risk summary

- Already packaged, no work: dinit, runit, s6 family, execline, mdevd,
  gardendevd, bubblewrap, doas, doas-sudo-shim, eudev, busybox, util-linux
- Needs testing: dinit as PID 1 under NixOS stage-2, runit service-tree
  generation, s6-rc database generation, gardendevd/mdevd as udev
  replacement
