# systemd {#sec-systemd-state}

## `machine-id(5)` {#sec-machine-id}

`systemd` uses per-machine identifier — {manpage}`machine-id(5)` — which must be
unique and persistent; otherwise, the system journal may fail to list earlier
boots, etc.

`systemd` generates a random `machine-id(5)` during boot if it does not already exist,
and persists it in `/etc/machine-id`.  As such, it suffices to make that file persistent.

Alternatively, it is possible to generate a random `machine-id(5)`; while the
specification allows for *any* hex-encoded 128b value, systemd itself uses
[UUIDv4], *i.e.* random UUIDs, and it is thus preferable to do so as well, in
case some software assumes `machine-id(5)` to be a UUIDv4. Those can be
generated with `uuidgen -r | tr -d -` (`tr` being used to remove the dashes).

Such a `machine-id(5)` can be set by writing it to `/etc/machine-id` or through
the kernel's command-line, though NixOS' systemd maintainers [discourage] the
latter approach.

[UUIDv4]: https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_(random)
[discourage]: https://github.com/NixOS/nixpkgs/pull/268995


## `/var/lib/systemd` {#sec-var-systemd}

Moreover, `systemd` expects its state directory — `/var/lib/systemd` — to persist, for:
- {manpage}`systemd-random-seed(8)`, which loads a 256b “seed” into the kernel's RNG
  at boot time, and saves a fresh one during shutdown;
- {manpage}`systemd.timer(5)` with `Persistent=yes`, which are then run after boot if
  the timer would have triggered during the time the system was shut down;
- {manpage}`systemd-coredump(8)` to store core dumps there by default;
  (see {manpage}`coredump.conf(5)`)
- {manpage}`systemd-timesyncd(8)`;
- {manpage}`systemd-backlight(8)` and {manpage}`systemd-rfkill(8)` persist hardware-related
  state;
- possibly other things, this list is not meant to be exhaustive.

In any case, making `/var/lib/systemd` persistent is recommended.


## `/var/log/journal/{machine-id}` {#sec-var-journal}

Lastly, {manpage}`systemd-journald(8)` writes the system's journal in binary
form to `/var/log/journal/{machine-id}`; if (locally) persisting the entire log
is desired, it is recommended to make all of `/var/log/journal` persistent.

If not, one can set `Storage=volatile` in {manpage}`journald.conf(5)`
([`services.journald.storage = "volatile";`](#opt-services.journald.storage)),
which disables journal persistence and causes it to be written to
`/run/log/journal`.
