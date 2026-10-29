# Taskserver {#module-services-taskserver}

Taskserver is the server component of the now deprecated version 2 of
[Taskwarrior](https://taskwarrior.org/), a free and
open source todo list application.

[Taskwarrior 3.0.0 was released in March
2024](https://github.com/GothenburgBitFactory/taskwarrior/releases/tag/v3.0.0),
and the sync functionality was rewritten entirely. With it, a NixOS module
named
[`taskchampion-sync-server`](options.html#opt-services.taskchampion-sync-server.enable)
was added to Nixpkgs. Many people still want to use the old [Taskwarrior
2.6.x](https://github.com/GothenburgBitFactory/taskwarrior/releases/tag/v2.6.2),
and Taskserver along with it. Hence this module and this documentation will
stay here for the near future.

## Configuration {#module-services-taskserver-configuration}

Taskserver does all of its authentication via TLS using client certificates,
so you either need to roll your own CA or purchase a certificate from a
known CA, which allows creation of client certificates. These certificates
are usually advertised as "server certificates".

So in order to make it easier to handle your own CA, there is a helper tool
called {command}`nixos-taskserver` which manages the custom CA along
with Taskserver organisations, users and groups.

While the client certificates in Taskserver only authenticate whether a user
is allowed to connect, every user has its own UUID which identifies it as an
entity.

With {command}`nixos-taskserver` the client certificate is created
along with the UUID of the user, so it handles all of the credentials needed
in order to setup the Taskwarrior 2 client to work with a Taskserver.

## The nixos-taskserver tool {#module-services-taskserver-nixos-taskserver-tool}

Because Taskserver by default only provides scripts to setup users
imperatively, the {command}`nixos-taskserver` tool is used for
addition and deletion of organisations along with users and groups defined
by [](#opt-services.taskserver.organisations) and as well for
imperative set up.

The tool is designed to not interfere if the command is used to manually set
up some organisations, users or groups.

For example if you add a new organisation using {command}`nixos-taskserver
org add foo`, the organisation is not modified and deleted no
matter what you define in
{option}`services.taskserver.organisations`, even if you're adding
the same organisation in that option.

The tool is modelled to imitate the official {command}`taskd`
command, documentation for each subcommand can be shown by using the
{option}`--help` switch.

## Declarative/automatic CA management {#module-services-taskserver-declarative-ca-management}

Everything is done according to what you specify in the module options,
however in order to set up a Taskwarrior 2 client for synchronisation with a
Taskserver instance, you have to transfer the keys and certificates to the
client machine.

This is done using {command}`nixos-taskserver user export $orgname
$username` which is printing a shell script fragment to stdout
which can either be used verbatim or adjusted to import the user on the
client machine.

For example, let's say you have the following configuration:
```ShellSession
{
  services.taskserver.enable = true;
  services.taskserver.fqdn = "server";
  services.taskserver.listenHost = "::";
  services.taskserver.organisations.my-company.users = [ "alice" ];
}
```
This creates an organisation called `my-company` with the
user `alice`.

Now in order to import the `alice` user to another machine
`alicebox`, all we need to do is something like this:
```ShellSession
$ ssh server nixos-taskserver user export my-company alice | sh
```
Of course, if no SSH daemon is available on the server you can also copy
&amp; paste it directly into a shell.

After this step the user should be set up and you can start synchronising
your tasks for the first time with {command}`task sync init` on
`alicebox`.

Subsequent synchronisation requests merely require the command {command}`task
sync` after that stage.

## Manual CA management {#module-services-taskserver-manual-ca-management}

If you set any options within
[service.taskserver.pki.manual](#opt-services.taskserver.pki.manual.ca.cert).*,
{command}`nixos-taskserver` won't issue certificates, but you can
still use it for adding or removing user accounts.
