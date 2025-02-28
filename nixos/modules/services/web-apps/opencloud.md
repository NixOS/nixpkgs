# OpenCloud {#module-services-opencloud}

[OpenCloud](https://opencloud.eu/en) is an open-source, modern file-sync and
sharing platform. It is a fork of oCIS, a ground-up rewrite of the well-known
PHP-based NextCloud server.

The server setup can be automated using
[services.opencloud](#opt-services.opencloud.enable).

## Basic usage {#module-services-opencloud-basic-usage}

OpenCloud is a golang application and does not require an HTTP server (such as
nginx) in front of it, though you may optionally use one if you will.

OpenCloud is configured using a combination of yaml and environment
variables. It is recommended to familiarize yourself with upstream's available
configuration options and deployment instructions:

A very basic configuration may look like this:
```
{ pkgs, ... }:
{
  services.opencloud = {
    enable = true;
    configDir = "/etc/opencloud/config";
  };
}
```

This will start the OpenCloud server and make it available at
`https://localhost:9200`.

However to make this configuration work you will need generate a configuration.
You can do this with:

```console
$ nix-shell -p opencloud
$ mkdir scratch/
$ cd scratch/
$ opencloud init --config-path . --admin-password "changeme"
```

You may need to pass `--insecure true` or provide the `OC_INSECURE = true;`
to [`services.opencloud.environment`][mod-envFile], if TLS certificates are
generated and managed externally (e.g. if you are using OpenCloud behind reverse
proxy).

If you want to manage the config file in your nix configuration, then it is
encouraged to use a secrets manager like sops-nix or agenix.

Be careful not to write files containing secrets to the globally readable nix
store.

Please note that current NixOS module for OpenCloud is configured to run in
`fullstack` mode, which starts all the services for OpenCloud in a single
instance, in so called supervised mode. This will start multiple OpenCloud
services and listen on multiple other ports.

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

You can also eschew the config file entirely and pass everything
to OpenCloud via environment variables. For this make use of
[`services.opencloud.environment`][mod-env] for non-sensitive values, and
[`services.opencloud.environmentFile`][mod-envFile] for sensitive values.

Configuration in (`services.opencloud.environment`)[mod-env] overrides those
from [`services.opencloud.environmentFile`][mod-envFile] and will have highest
precedence.


[mod-env]: #opt-services.opencloud.environment
[mod-envFile]: #opt-services.opencloud.environmentFile
