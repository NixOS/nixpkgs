# Open Energy Management System {#module-services-openems}

A modular platform for energy management applications.

Please also refer to the [full OpenEMS documentation](https://openems.io/openems/latest/introduction.html).

## Basic usage {#module-services-openems-basic-usage}

OpenEMS can be configured to run [edge nodes](https://openems.github.io/openems.io//openems/latest/edge/architecture.html):

```nix
{ ... }:

{
  services.openems.edge = {
    enable = true;
  };
}
```

...and [backend nodes](https://openems.github.io/openems.io//openems/latest/backend/architecture.html):

```nix
{ ... }:

{
  services.openems.backend = {
    enable = true;
  };
}
```

Enable a backend node if you intend to aggregate data from multiple edge nodes.

After enabling a node, OSGi components must be provisioned before the node is fully operational,
see [Configuration](#module-services-openems-config) below.

You can modify the default configuration:

```nix
{ config, ... }:

{
  services.openems = {
    edge = {
      enable = true;
      dataDir = "/var/lib/edge.d"; # Default: "/var/lib/openems.d"
      ui = {
        enable = true;
        port = 4567; # Default: 8085
        openFirewall = true;
      };
      felix = {
        port = 4568; # Default: 8080
        openFirewall = true;
      };
      watchdog.timeout = null; # Disable watchdog (default 60 s)
    };
    backend = {
      enable = true;
      dataDir = "/var/lib/backend.d"; # Default: "/var/lib/openems-backend/config.d"
      ui = {
        port = 4567; # Default: 8082
        openFirewall = true;
      };
      edgeManager = {
        port = 4568; # Default: 8081
        openFirewall = true;
      };
      felix = {
        port = 4569; # Default: 8079
        openFirewall = true;
      };
      watchdog.timeout = null; # Disable watchdog (default 60 s)
    };
    ui = {
      enable = true;
      hostName = "openems.io";
      websocket.port = config.services.openems.edge.websocket.port; # Default: 8082
    };
  };
}
```

## Configuration {#module-services-openems-config}

OpenEMS edge and backend nodes use the [OSGi platform](https://en.wikipedia.org/wiki/OSGi)
for component configuration.
Each component must be configured via a file that lives in the specified `dataDir`.
Because the configuration files can contain secrets, they should not live in the Nix store
and must be provisioned manually.

:::{.note}
Due to the large and constantly growing number of OSGi component configurations
that OpenEMS supports, the NixOS module only provisions the minimal set of
components needed to start and connect the services. All other components must be configured
via `dataDir`.
:::

You can manage component configuration interactively using the
[Apache Felix Web Console](https://openems.io//openems/latest/gettingstarted.html#_basic_configuration)
at `http://localhost:<felix.port>/system/console/configMgr`,
or via the
[Apache Felix Web Console REST API](https://felix.apache.org/documentation/subprojects/apache-felix-web-console/web-console-restful-api.html).

:::{.warning}
The default Felix Web Console credentials are `admin`/`admin`.
These should be changed before exposing the port to untrusted networks.
:::

For example, to configure edge node authentication for a backend node
(adjust the port to match your `felix.port`):

```bash
curl -u admin:admin \
  -d 'apply=true' \
  -d 'pid=Metadata.Dummy' \
  -d 'propertylist=edgeIdMax,edgeIdTemplate' \
  -d 'edgeIdMax=1' \
  -d 'edgeIdTemplate=edge%25d' \
  http://localhost:8079/system/console/configMgr/Metadata.Dummy
```

...and to configure a connection to a backend for an edge node:

```bash
curl -u admin:admin \
  -d 'apply=true' \
  -d 'factoryPid=Controller.Api.Backend' \
  -d 'propertylist=id,uri,apikey,enabled' \
  -d 'id=ctrlBackend0' \
  -d 'uri=ws://backend:1234' \
  -d 'apikey=DEMO_API_KEY' \
  -d 'enabled=true' \
  http://localhost:8080/system/console/configMgr/Controller.Api.Backend
```

## UI {#module-services-openems-ui}

The `services.openems.ui` module enables an nginx server that servers the OpenEMS web UI,
built with the default theme and configured to connect to an OpenEMS edge or backend node
via `ws://localhost:<port>`, where `<port>` is set by `services.openems.ui.websocket.port`
(defaults to `8082`, the same default as `services.openems.backend.ui.port`).

To use a custom theme or branding, you will need to provide your own fork of the
OpenEMS source and override the `openems-ui` package. Refer to the
[OpenEMS UI documentation](https://openems.io/openems/latest/ui/build.html) for
available build options.
