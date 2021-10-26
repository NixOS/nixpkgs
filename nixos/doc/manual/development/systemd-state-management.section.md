## State management {#sec-systemd-state-management}

State refers to files and directories for config or running a service.
A special section is dedicated at the end regarding databases.

TODO: section on RuntimeDir, StateDir, WorkingDir

### Database connection {#sec-systemd-state-management-database-connection}

Most databases have 2 modes of connection, over TCP or over Unix socket. Connecting over a unix socket can provide 2 advantages
- 30% performance improvement as packets don't need to be encoder over TCP
- The default authentication mode postgres on unix sockets is just with the user name. This will remove the need to manage the password secret

Therefore the default for database connection for services is recommended to be with a unix socket. For postgres for example, the `host` needs to start with a `/`.
[nixpkgs-example](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/lemmy.nix#L98)

### Database initialisation {#sec-systemd-state-management-database-initialisation}

To initialise a database that a service depends on, it's customary to create another systemd service that will be `partOf` your main service.
The initialisation service should be run by the database superuser so as not to require sudo.
Typically it will involve creating the database and the user.
There will be a step to see if the database is already created.
That check is best implemented by going throug the created tables and exiting if the table already exists.
[nixpkgs-example](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/lemmy.nix#L220)
