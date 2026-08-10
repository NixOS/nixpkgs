# Proxmox Backup Server on NixOS

This is the documentation hub for the **NixOS packaging of Proxmox Backup
Server**: PBS built as a native Nix package and run from a systemd service,
with no Debian container.

The full upstream PBS manual is bundled and served right next to this page:

> 📖 **[Proxmox Backup Server manual](proxmox/index.html)**

Use the upstream manual for everything about datastores, backups, pruning,
verification, tape, and the API. The rest of this page covers only what is
specific to the NixOS port.

## Heads up: this is an unofficial port

This packaging is **unofficial**. It is not supported by Proxmox Server
Solutions GmbH, so please do not contact Proxmox support about it. Report
problems on the [nixpkgs issue tracker](https://github.com/NixOS/nixpkgs/issues)
instead, and test on something you can afford to lose before trusting it with
real backups.

## How this port differs

- **Service user and group**: PBS runs as `proxmox-backup-server` rather than
  the Debian default `backup`, and keeps its state under
  `/var/lib/proxmox-backup` and in `/etc/proxmox-backup`.

- **FHS-wrapped daemons**: PBS hardcodes Debian-style paths such as
  `/usr/share/javascript/proxmox-backup` and
  `/usr/lib/<multiarch>/proxmox-backup`, so the binaries run inside a bubblewrap
  FHS environment that provides them. Prefer the NixOS module options over
  editing files by hand. One consequence concerns where datastores may live;
  see [Datastore paths](#datastore-paths) below.

- **Trimmed web UI**: features that cannot work on an immutable NixOS host are
  removed from the interface. APT updates and repositories, network and time
  configuration, and the reboot and shutdown buttons are gone, along with the
  two menus below.

  - **Shell**: there is no host xterm console to attach to.
  - **Storage / Disks**: disk management would write `systemd` mount units into
    `/etc/systemd/system`, which is a read-only nix-store path. The matching API
    endpoints are compiled in but will not work. Mount the filesystem
    declaratively with `fileSystems` instead, then create a datastore on it
    (its mount path works directly; see [Datastore paths](#datastore-paths)).

- **Documentation**: this page is served at `/docs`, and the upstream manual
  lives at `/docs/proxmox`. The Documentation button in the top bar opens this
  page.

## Getting started

The web login uses PAM, so you can sign in as `root@pam` with the host's root
password. From there, or from a shell on the host, create your first datastore:

```sh
proxmox-backup-manager datastore create main /var/lib/proxmox-backup/datastores/main
```

The web UI does the same thing through **Add Datastore**. Once a datastore
exists, follow the [upstream manual](proxmox/index.html) for backup clients,
scheduling, pruning, verification, and sync jobs.

### Declarative datastores and jobs

This port can also manage datastores and prune/verify/sync jobs declaratively
from your NixOS configuration, so a host comes up with them already in place. A
`proxmox-backup-setup` service reconciles the declared resources on activation,
creating them if missing and updating them to match, while leaving anything you
add by hand in the GUI untouched. See the `services.proxmox-backup-server`
options (`man configuration.nix` or
[search.nixos.org](https://search.nixos.org/options?query=services.proxmox-backup-server))
for the options and examples.

### Datastore paths

The daemons run inside the FHS sandbox, but the wrapper automatically
bind-mounts **every top-level host directory** into the sandbox at the same path
(recursively, so submounts such as a ZFS pool or a dedicated disk come along).
So datastores on the usual locations **work out of the box at their normal host
paths**, no prefix or extra setup needed:

- `/var/...` (e.g. the default `/var/lib/proxmox-backup/datastores/...`)
- `/mnt/...`, `/media/...`, `/srv/...`, `/opt/...`
- `/home/...`, `/root/...`, `/boot/...`, `/tmp/...`
- any custom top-level mount, e.g. a ZFS pool at `/tank/...` or a disk at
  `/data/...`

The only top-level names that are **not** bridged are the ones the sandbox owns
or ignores: `/usr`, `/bin`, `/sbin`, `/lib`, `/lib32`, `/lib64`, `/libexec`,
`/nix`, `/dev`, `/proc`, `/etc`; you would not site a datastore in any of those
anyway.

The one path that does **not** work is the **bare filesystem root `/`**: the
sandbox `/` is a throwaway namespace root, so a datastore created directly at `/`
is written there and **silently vanishes on the next request**. Create a
directory (or a mountpoint) under it instead, e.g. `/mydata`.

Binds are set up when the daemons start, so a directory or mountpoint created
*after* they are already running is not visible yet. **Restart the PBS
services** (`systemctl restart proxmox-backup proxmox-backup-proxy`) after
creating a new top-level directory or mounting a new filesystem there, then
create the datastore. Declarative `fileSystems` mounts (mounted at boot, before
PBS starts) don't need this.

To install the port on your own host, enable `services.proxmox-backup-server`
in your NixOS configuration; see the option documentation linked above for the
full list of settings.

**Tape backup is untested and likely does not work.** The tape tooling
(`proxmox-tape`, `pmt`, `pmtx`, `sg-tape-cmd`) is built and its UI is left in
place, but it has not been exercised on this port and is not expected to work
as-is. If you need tape, please open an
[issue](https://github.com/NixOS/nixpkgs/issues) so it can be looked at.
