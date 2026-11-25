# Versity S3 Gateway {#module-services-versitygw}

[Versity S3 Gateway](https://github.com/versity/versitygw) exposes a filesystem
through an S3-compatible API. It requires a filesystem with extended attributes.

```nix
{
  services.versitygw = {
    enable = true;
    rootDirectory = "/srv/versitygw";
    environmentFile = "/run/secrets/versitygw.env";
    settings.VGW_PORT = "127.0.0.1:7070";
  };
}
```

Provision `environmentFile` at runtime with `ROOT_ACCESS_KEY` and
`ROOT_SECRET_KEY`. Do not use `pkgs.writeText` or a Nix path literal for real
credentials: those put secrets in the world-readable Nix store.

The service does not open firewall ports. Without an explicit `VGW_PORT`,
VersityGW listens on all interfaces on port 7070. Set an appropriate bind
address and configure TLS or a reverse proxy before exposing the gateway.
Additional upstream flags can be configured through their environment variables
in [](#opt-services.versitygw.settings).

The internal IAM store is kept in `/var/lib/versitygw/iam`. Optional
[](#opt-services.versitygw.usersFile) seeds the upstream JSON account store before
every start. Its top-level `accessAccounts` object maps access keys to account
records with `access`, `secret`, `role`, `userID`, `groupID` and `projectID` fields.
Render this file with a secret manager and keep the source root-readable only.
When this option is set, runtime account changes are replaced on restart.

Manage buckets and policies through the upstream administration CLI or an S3
client. This module does not reconcile or delete buckets, objects or policies.
Objects remain ordinary files below [](#opt-services.versitygw.rootDirectory),
so backup both that directory and the IAM state directory.
