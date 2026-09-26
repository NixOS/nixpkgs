# OpenCloud {#module-services-opencloud}

[OpenCloud](https://opencloud.eu/en) is an open-source, modern file-sync and
sharing platform. It is a fork of oCIS, a ground-up rewrite of the well-known
PHP-based NextCloud server.

The service can be configured using a combination of [](#opt-services.opencloud.settings),
[](#opt-services.opencloud.environment) and [](#opt-services.opencloud.environmentFile).

## Basic usage {#module-services-opencloud-basic-usage}

OpenCloud is configured using a combination of YAML and environment
variables. The full documentation can be found at
[OpenCloud Admin Docs](https://docs.opencloud.eu/docs/admin/intro).

The general flow of configuring OpenCloud is:
- configure services with `services.opencloud.settings.<service>` when possible
- configure global settings that affect multiple services via `services.opencloud.environment`
- allow NixOS to provision a default `opencloud.yaml` for you, containing default credentials
  for communication between the microservices
- provide additional secrets via `environmentFile`, provisioned out of band

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
