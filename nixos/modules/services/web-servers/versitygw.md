# Versity S3 Gateway {#module-services-versitygw}

[Versity S3 Gateway](https://github.com/versity/versitygw) exposes a filesystem
through an S3-compatible API. It requires a filesystem with extended attributes.

```nix
{
  services.versitygw = {
    enable = true;
    rootDirectory = "/srv/versitygw";
    environmentFile = "/run/secrets/versitygw.env";
    settings = {
      VGW_PORT = "127.0.0.1:7070";
      VGW_ADMIN_PORT = "127.0.0.1:7080";
    };
  };
}
```

Provision [](#opt-services.versitygw.environmentFile) at runtime with
`ROOT_ACCESS_KEY` and `ROOT_SECRET_KEY`. Do not put credentials in
[](#opt-services.versitygw.settings): its values become part of the
world-readable Nix store, and the module rejects root credential keys there.
Likewise, do not use `pkgs.writeText` or a Nix path literal for real credentials.

For example, with [sops-nix](https://github.com/Mic92/sops-nix) already
configured and secrets `versitygw_access_key` and `versitygw_secret_key`
declared, a template can produce the environment file at activation:

```nix
{ config, ... }:
{
  sops.templates."versitygw.env" = {
    restartUnits = [ "versitygw.service" ];
    content = ''
      ROOT_ACCESS_KEY=${config.sops.placeholder.versitygw_access_key}
      ROOT_SECRET_KEY=${config.sops.placeholder.versitygw_secret_key}
    '';
  };
  services.versitygw.environmentFile = config.sops.templates."versitygw.env".path;
}
```

The template placeholders are replaced in the rendered file, not in arbitrary
NixOS options such as `settings`. The example assumes secret values are valid
unquoted systemd environment-file values; values containing special characters
must be encoded according to the `EnvironmentFile=` syntax. Restrict access to
the rendered file: the service receives these credentials at runtime.

The service does not open firewall ports. Without an explicit `VGW_PORT`,
VersityGW listens on all interfaces on port 7070. Set an appropriate bind
address and configure TLS or a reverse proxy before exposing the gateway.
Without `VGW_ADMIN_PORT`, the admin API shares the S3 listener. The example
separates it onto loopback port 7080; forward only the S3 listener through a
public reverse proxy and keep the admin endpoint restricted. Configure the
administration CLI to use `http://127.0.0.1:7080` on the gateway host.

A separate admin listener does not inherit the S3 TLS certificate and key.
Unless both `VGW_ADMIN_CERT` and `VGW_ADMIN_CERT_KEY` are set, it serves plaintext
HTTP, even when S3 uses TLS. If exposing it beyond loopback, configure its own
TLS certificate pair or a restricted TLS-terminating proxy. The certificate and
key files must be readable by the service user; keep private keys out of the
Nix store.

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
so back up both that directory and the IAM state directory.

## External metadata and version storage {#module-services-versitygw-external-storage}

The POSIX backend can use `VGW_META_SIDECAR` for sidecar metadata and
`VGW_VERSIONING_DIR` for non-current object versions. Both directories must
already exist outside the object root and be writable by the service user.
The service uses `ProtectSystem=strict`, so filesystem ownership alone is not
enough: also add these paths to `ReadWritePaths`. For the default service user:

```nix
{
  services.versitygw.settings = {
    VGW_META_SIDECAR = "/srv/s3-metadata";
    VGW_VERSIONING_DIR = "/srv/s3-versions";
  };
  systemd.tmpfiles.rules = [
    "d /srv/s3-metadata 0750 versitygw versitygw -"
    "d /srv/s3-versions 0750 versitygw versitygw -"
  ];
  systemd.services.versitygw.serviceConfig.ReadWritePaths = [
    "/srv/s3-metadata"
    "/srv/s3-versions"
  ];
}
```

This extends the module's writable paths without disabling its filesystem
sandbox. Adapt the directory ownership when using a custom service user or
group. Use absolute paths; avoid sidecar paths sharing the object root's string
prefix, which upstream also rejects. Back up these directories together with
the object and IAM stores. Setting `VGW_VERSIONING_DIR` enables versioning
support, but each bucket still needs versioning enabled through the S3 API.
