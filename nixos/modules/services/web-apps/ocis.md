# ownCloud Infinite Scale {#module-services-ocis}

[ownCloud Infinite Scale](https://owncloud.dev/ocis/) (oCIS) is an open-source,
modern file-sync and sharing platform. It is a ground-up rewrite of the well-known PHP based ownCloud server.

The server setup can be automated using
[services.ocis](#opt-services.ocis.enable). The desktop client is packaged at
`pkgs.owncloud-client`.

## Basic usage {#module-services-ocis-basic-usage}

oCIS is a golang application and does not require an HTTP server (such as nginx)
in front of it, though you may optionally use one if you will.

oCIS is configured using a combination of yaml and environment variables. It is
recommended to familiarize yourself with upstream's available configuration
options and deployment instructions:

* [Getting Started](https://owncloud.dev/ocis/getting-started/)
* [Configuration](https://owncloud.dev/ocis/config/)
* [Basic Setup](https://owncloud.dev/ocis/deployment/basic-remote-setup/)

A very basic configuration may look like this:
```
{ pkgs, ... }:
{
  services.ocis = {
    enable = true;
    configDir = "/etc/ocis/config";
  };
}
```

This will start the oCIS server and make it available at `https://0.0.0.0:9200`

The oCIS will automatically initialize the oCIS server and generate a temporary admin
password on first use, the password will be displayed in the journal for the service.

`$ systemctl status ocis-setup` or `$ journalctl -u ocis-setup`

the initialization routine will not run as long as the ocis.yaml exists in the
`services.ocis.configDir` to re-initialize oCIS simply remove the ocis.yaml file from that folder.

You may need to pass `--insecure true` or provide the `OCIS_INSECURE = true;` to
[`services.ocis.environment`][mod-envFile], if TLS certificates are generated
and managed externally (e.g. if you are using oCIS behind reverse proxy).

support for ACME Certificates is available via `ocis.useACMEHost = 'your.host.name';`

If you want to manage the config file in your nix configuration, then it is
encouraged to use a secrets manager like sops-nix or agenix.

Be careful not to write files containing secrets to the globally readable nix
store.

Please note that current NixOS module for oCIS is configured to run in `fullstack`
mode, which starts all the services for owncloud on single instance. This will
start multiple ocis services and listen on multiple other ports.

Current known services and their ports are as below:

| Service            | Group   |  Port |
|--------------------|---------|-------|
| gateway            | api     |  9142 |
| sharing            | api     |  9150 |
| app-registry       | api     |  9242 |
| ocdav              | web     | 45023 |
| auth-machine       | api     |  9166 |
| storage-system     | api     |  9215 |
| webdav             | web     |  9115 |
| webfinger          | web     | 46871 |
| storage-system     | web     |  9216 |
| web                | web     |  9100 |
| eventhistory       | api     | 33177 |
| ocs                | web     |  9110 |
| storage-publiclink | api     |  9178 |
| settings           | web     |  9190 |
| ocm                | api     |  9282 |
| settings           | api     |  9191 |
| ocm                | web     |  9280 |
| app-provider       | api     |  9164 |
| storage-users      | api     |  9157 |
| auth-service       | api     |  9199 |
| thumbnails         | web     |  9186 |
| thumbnails         | api     |  9185 |
| storage-shares     | api     |  9154 |
| sse                | sse     | 46833 |
| userlog            | userlog | 45363 |
| search             | api     |  9220 |
| proxy              | web     |  9200 |
| idp                | web     |  9130 |
| frontend           | web     |  9140 |
| groups             | api     |  9160 |
| graph              | graph   |  9120 |
| users              | api     |  9144 |
| auth-basic         | api     |  9146 |

## Configuration via environment variables

You can also eschew the config file entirely and pass everything to oCIS via
environment variables. For this make use of
[`services.ocis.environment`][mod-env] for non-sensitive
values, and
[`services.ocis.environmentFile`][mod-envFile] for
sensitive values.

Configuration in (`services.ocis.environment`)[mod-env] overrides those from
[`services.ocis.environmentFile`][mod-envFile] and will have highest
precedence

the `services.ocis.insecure` value will always override any value set since it is passed directly
as a CLI argument to the oCIS binary

[mod-env]: #opt-services.ocis.environment
[mod-envFile]: #opt-services.ocis.environmentFile
