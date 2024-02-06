# FoundationDB {#module-services-foundationdb}

*Source:* {file}`modules/services/databases/foundationdb.nix`

*Upstream documentation:* <https://apple.github.io/foundationdb/>

*Maintainer:* Austin Seipp

*Available version(s):* 7.1.x

FoundationDB (or "FDB") is an open source, distributed, transactional
key-value store.

## Configuring and basic setup {#module-services-foundationdb-configuring}

To enable FoundationDB, add the following to your
{file}`configuration.nix`:
```
services.foundationdb.enable = true;
services.foundationdb.package = pkgs.foundationdb71; # FoundationDB 7.1.x
```

The {option}`services.foundationdb.package` option is required, and
must always be specified. Due to the fact FoundationDB network protocols and
on-disk storage formats may change between (major) versions, and upgrades
must be explicitly handled by the user, you must always manually specify
this yourself so that the NixOS module will use the proper version. Note
that minor, bugfix releases are always compatible.

After running {command}`nixos-rebuild`, you can verify whether
FoundationDB is running by executing {command}`fdbcli` (which is
added to {option}`environment.systemPackages`):
```ShellSession
$ sudo -u foundationdb fdbcli
Using cluster file `/etc/foundationdb/fdb.cluster'.

The database is available.

Welcome to the fdbcli. For help, type `help'.
fdb> status

Using cluster file `/etc/foundationdb/fdb.cluster'.

Configuration:
  Redundancy mode        - single
  Storage engine         - memory
  Coordinators           - 1

Cluster:
  FoundationDB processes - 1
  Machines               - 1
  Memory availability    - 5.4 GB per process on machine with least available
  Fault Tolerance        - 0 machines
  Server time            - 04/20/18 15:21:14

...

fdb>
```

You can also write programs using the available client libraries. For
example, the following Python program can be run in order to grab the
cluster status, as a quick example. (This example uses
{command}`nix-shell` shebang support to automatically supply the
necessary Python modules).
```ShellSession
a@link> cat fdb-status.py
#! /usr/bin/env nix-shell
#! nix-shell -i python -p python pythonPackages.foundationdb71

import fdb
import json

def main():
    fdb.api_version(520)
    db = fdb.open()

    @fdb.transactional
    def get_status(tr):
        return str(tr['\xff\xff/status/json'])

    obj = json.loads(get_status(db))
    print('FoundationDB available: %s' % obj['client']['database_status']['available'])

if __name__ == "__main__":
    main()
a@link> chmod +x fdb-status.py
a@link> ./fdb-status.py
FoundationDB available: True
a@link>
```

FoundationDB is run under the {command}`foundationdb` user and group
by default, but this may be changed in the NixOS configuration. The systemd
unit {command}`foundationdb.service` controls the
{command}`fdbmonitor` process.

By default, the NixOS module for FoundationDB creates a single SSD-storage
based database for development and basic usage. This storage engine is
designed for SSDs and will perform poorly on HDDs; however it can handle far
more data than the alternative "memory" engine and is a better default
choice for most deployments. (Note that you can change the storage backend
on-the-fly for a given FoundationDB cluster using
{command}`fdbcli`.)

Furthermore, only 1 server process and 1 backup agent are started in the
default configuration. See below for more on scaling to increase this.

FoundationDB stores all data for all server processes under
{file}`/var/lib/foundationdb`. You can override this using
{option}`services.foundationdb.dataDir`, e.g.
```
services.foundationdb.dataDir = "/data/fdb";
```

Similarly, logs are stored under {file}`/var/log/foundationdb`
by default, and there is a corresponding
{option}`services.foundationdb.logDir` as well.

## Scaling processes and backup agents {#module-services-foundationdb-scaling}

Scaling the number of server processes is quite easy; simply specify
{option}`services.foundationdb.serverProcesses` to be the number of
FoundationDB worker processes that should be started on the machine.

FoundationDB worker processes typically require 4GB of RAM per-process at
minimum for good performance, so this option is set to 1 by default since
the maximum amount of RAM is unknown. You're advised to abide by this
restriction, so pick a number of processes so that each has 4GB or more.

A similar option exists in order to scale backup agent processes,
{option}`services.foundationdb.backupProcesses`. Backup agents are
not as performance/RAM sensitive, so feel free to experiment with the number
of available backup processes.

## Clustering {#module-services-foundationdb-clustering}

FoundationDB on NixOS works similarly to other Linux systems, so this
section will be brief. Please refer to the full FoundationDB documentation
for more on clustering.

FoundationDB organizes clusters using a set of
*coordinators*, which are just specially-designated
worker processes. By default, every installation of FoundationDB on NixOS
will start as its own individual cluster, with a single coordinator: the
first worker process on {command}`localhost`.

Coordinators are specified globally using the
{command}`/etc/foundationdb/fdb.cluster` file, which all servers and
client applications will use to find and join coordinators. Note that this
file *can not* be managed by NixOS so easily:
FoundationDB is designed so that it will rewrite the file at runtime for all
clients and nodes when cluster coordinators change, with clients
transparently handling this without intervention. It is fundamentally a
mutable file, and you should not try to manage it in any way in NixOS.

When dealing with a cluster, there are two main things you want to do:

  - Add a node to the cluster for storage/compute.
  - Promote an ordinary worker to a coordinator.

A node must already be a member of the cluster in order to properly be
promoted to a coordinator, so you must always add it first if you wish to
promote it.

To add a machine to a FoundationDB cluster:

  - Choose one of the servers to start as the initial coordinator.
  - Copy the {command}`/etc/foundationdb/fdb.cluster` file from this
    server to all the other servers. Restart FoundationDB on all of these
    other servers, so they join the cluster.
  - All of these servers are now connected and working together in the
    cluster, under the chosen coordinator.

At this point, you can add as many nodes as you want by just repeating the
above steps. By default there will still be a single coordinator: you can
use {command}`fdbcli` to change this and add new coordinators.

As a convenience, FoundationDB can automatically assign coordinators based
on the redundancy mode you wish to achieve for the cluster. Once all the
nodes have been joined, simply set the replication policy, and then issue
the {command}`coordinators auto` command

For example, assuming we have 3 nodes available, we can enable double
redundancy mode, then auto-select coordinators. For double redundancy, 3
coordinators is ideal: therefore FoundationDB will make
*every* node a coordinator automatically:

```ShellSession
fdbcli> configure double ssd
fdbcli> coordinators auto
```

This will transparently update all the servers within seconds, and
appropriately rewrite the {command}`fdb.cluster` file, as well as
informing all client processes to do the same.

## Client connectivity {#module-services-foundationdb-connectivity}

By default, all clients must use the current {command}`fdb.cluster`
file to access a given FoundationDB cluster. This file is located by default
in {command}`/etc/foundationdb/fdb.cluster` on all machines with the
FoundationDB service enabled, so you may copy the active one from your
cluster to a new node in order to connect, if it is not part of the cluster.

## Client authorization and TLS {#module-services-foundationdb-authorization}

By default, any user who can connect to a FoundationDB process with the
correct cluster configuration can access anything. FoundationDB uses a
pluggable design to transport security, and out of the box it supports a
LibreSSL-based plugin for TLS support. This plugin not only does in-flight
encryption, but also performs client authorization based on the given
endpoint's certificate chain. For example, a FoundationDB server may be
configured to only accept client connections over TLS, where the client TLS
certificate is from organization *Acme Co* in the
*Research and Development* unit.

Configuring TLS with FoundationDB is done using the
{option}`services.foundationdb.tls` options in order to control the
peer verification string, as well as the certificate and its private key.

Note that the certificate and its private key must be accessible to the
FoundationDB user account that the server runs under. These files are also
NOT managed by NixOS, as putting them into the store may reveal private
information.

After you have a key and certificate file in place, it is not enough to
simply set the NixOS module options -- you must also configure the
{command}`fdb.cluster` file to specify that a given set of
coordinators use TLS. This is as simple as adding the suffix
{command}`:tls` to your cluster coordinator configuration, after the
port number. For example, assuming you have a coordinator on localhost with
the default configuration, simply specifying:

```
XXXXXX:XXXXXX@127.0.0.1:4500:tls
```

will configure all clients and server processes to use TLS from now on.

## Backups and Disaster Recovery {#module-services-foundationdb-disaster-recovery}

The usual rules for doing FoundationDB backups apply on NixOS as written in
the FoundationDB manual. However, one important difference is the security
profile for NixOS: by default, the {command}`foundationdb` systemd
unit uses *Linux namespaces* to restrict write access to
the system, except for the log directory, data directory, and the
{command}`/etc/foundationdb/` directory. This is enforced by default
and cannot be disabled.

However, a side effect of this is that the {command}`fdbbackup`
command doesn't work properly for local filesystem backups: FoundationDB
uses a server process alongside the database processes to perform backups
and copy the backups to the filesystem. As a result, this process is put
under the restricted namespaces above: the backup process can only write to
a limited number of paths.

In order to allow flexible backup locations on local disks, the FoundationDB
NixOS module supports a
{option}`services.foundationdb.extraReadWritePaths` option. This
option takes a list of paths, and adds them to the systemd unit, allowing
the processes inside the service to write (and read) the specified
directories.

For example, to create backups in {command}`/opt/fdb-backups`, first
set up the paths in the module options:

```
services.foundationdb.extraReadWritePaths = [ "/opt/fdb-backups" ];
```

Restart the FoundationDB service, and it will now be able to write to this
directory (even if it does not yet exist.) Note: this path
*must* exist before restarting the unit. Otherwise,
systemd will not include it in the private FoundationDB namespace (and it
will not add it dynamically at runtime).

You can now perform a backup:

```ShellSession
$ sudo -u foundationdb fdbbackup start  -t default -d file:///opt/fdb-backups
$ sudo -u foundationdb fdbbackup status -t default
```

## Known limitations {#module-services-foundationdb-limitations}

The FoundationDB setup for NixOS should currently be considered beta.
FoundationDB is not new software, but the NixOS compilation and integration
has only undergone fairly basic testing of all the available functionality.

  - There is no way to specify individual parameters for individual
    {command}`fdbserver` processes. Currently, all server processes
    inherit all the global {command}`fdbmonitor` settings.
  - Ruby bindings are not currently installed.
  - Go bindings are not currently installed.

## Options {#module-services-foundationdb-options}

NixOS's FoundationDB module allows you to configure all of the most relevant
configuration options for {command}`fdbmonitor`, matching it quite
closely. A complete list of options for the FoundationDB module may be found
[here](#opt-services.foundationdb.enable). You should
also read the FoundationDB documentation as well.

## Full documentation {#module-services-foundationdb-full-docs}

FoundationDB is a complex piece of software, and requires careful
administration to properly use. Full documentation for administration can be
found here: <https://apple.github.io/foundationdb/>.
