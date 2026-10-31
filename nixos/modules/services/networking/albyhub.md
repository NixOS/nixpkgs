# Alby Hub {#module-services-albyhub}

[Alby Hub](https://albyhub.com/) is a self-custodial Lightning wallet server with
a web interface and Nostr Wallet Connect support. It can manage its own embedded
LDK node or connect to an external Lightning backend such as LND or phoenixd.

## Basic Usage {#module-services-albyhub-basic-usage}

A minimal configuration starts the Hub on the module's default local port:

```nix
{
  services.albyhub.enable = true;
}
```

By default, the module creates a dedicated `albyhub` system user and group,
stores state under `/var/lib/albyhub`, writes Hub's runtime `.env` file in that
directory, and runs the service with systemd hardening enabled.

These defaults are intended to be safe starting points for a local service that
is either accessed directly on the machine or placed behind a reverse proxy.
After the first start, Hub can still be configured through its web interface
unless you deliberately force a backend configuration.

## Common Settings {#module-services-albyhub-common-settings}

Most installations only need to set the public URL and, when using an external
Lightning node, the backend connection details.

```nix
{
  services.albyhub = {
    enable = true;
    autoLinkAlbyAccount = true;
    baseUrl = "https://hub.example.local";
    mempoolApi = "https://mempool.example.local/api";
  };
}
```

Set {option}`services.albyhub.baseUrl` when Hub is reachable through a real
hostname. This is required for custom Alby OAuth clients because the callback URL
is derived from it. Set {option}`services.albyhub.frontendUrl` separately only
when browser redirects should use a different public URL than the backend.

Set {option}`services.albyhub.network`, {option}`services.albyhub.mempoolApi`,
or {option}`services.albyhub.boltzApi` for signet, regtest, custom chain data
providers, or non-default swap infrastructure.

The module defaults {option}`services.albyhub.autoLinkAlbyAccount` to `false` so
starting a NixOS service does not implicitly associate the instance with the
currently authenticated Alby account. Enable it only when you want that linking
to happen automatically.

## Lightning Backends {#module-services-albyhub-lightning-backends}

Alby Hub supports backend settings through environment variables. The module
exposes common service-level settings as Nix options and leaves
backend-specific variables to {option}`services.albyhub.extraConfig`.

Use `extraConfig` for non-secret `KEY=value` lines that Hub understands but the
module does not model directly:

```nix
{
  services.albyhub.extraConfig = ''
    LN_BACKEND_TYPE=LND
    LND_ADDRESS=127.0.0.1:10009
    LND_CERT_FILE=/var/lib/albyhub/lnd-tls.cert
    LND_MACAROON_FILE=/var/lib/albyhub/lnd-admin.macaroon
  '';
}
```

For LND, use a client-reachable address such as `127.0.0.1:10009`. The `albyhub`
service user must be able to read the certificate and macaroon files. Copy both
files to a path readable by Hub, such as its {option}`services.albyhub.dataDir`,
and point `LND_CERT_FILE` and `LND_MACAROON_FILE` at those copies. Advanced
setups can orchestrate these files declaratively with a secrets manager such as
[sops-nix](https://github.com/Mic92/sops-nix).

For phoenixd, the non-secret endpoint can be declared in `extraConfig`, but the
API password should be supplied with your normal NixOS secret-management
workflow rather than written directly into a Nix string:

```nix
{
  services.albyhub.extraConfig = ''
    LN_BACKEND_TYPE=PHOENIX
    PHOENIXD_ADDRESS=http://127.0.0.1:9740
  '';
}
```

See the [upstream user guide](https://guides.getalby.com/user-guide/alby-hub)
and the Hub README for the complete backend variable list.

## Secrets {#module-services-albyhub-secrets}

Do not put secrets in {option}`services.albyhub.extraConfig`, because Nix strings
can be stored in the Nix store. This includes OAuth client secrets, JWT secrets,
auto-unlock passwords, phoenixd API passwords, and copied admin macaroons.

The module provides file-based options for some secrets:

```nix
{
  services.albyhub = {
    autoUnlockPasswordFile = "/run/secrets/albyhub-unlock-password";
    jwtSecretFile = "/run/secrets/albyhub-jwt-secret";
    albyOAuth.clientSecretFile = "/run/secrets/albyhub-oauth-secret";
  };
}
```

Use {option}`services.albyhub.autoUnlockPasswordFile` only for unattended
restarts where you accept the trade-off: Hub can unlock itself on boot, but the
unlock secret is now available to the service at runtime.
